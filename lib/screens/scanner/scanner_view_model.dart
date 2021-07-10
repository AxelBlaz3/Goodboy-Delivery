import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/address.dart';
import 'package:delivery_app/models/delivery_agent.dart';
import 'package:delivery_app/models/subscriber.dart';
import 'package:delivery_app/models/subscription.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScannerViewModel extends ChangeNotifier {
  bool isScanned = false;
  List<int> selectedIndices = <int>[];
  XFile? _image;
  Box<Subscription> deliveries = Hive.box<Subscription>(kDeliveryBoxName);
  List<Subscription> todayDeliveries = <Subscription>[];

  XFile? get capturedImage => _image;
  void setCapturedImage(XFile? capturedImage, {bool shouldNotify = true}) {
    _image = capturedImage;
    if (shouldNotify) notifyListeners();
  }

  void updateSelectedIndices(int index) {
    final bool isSelected = selectedIndices.contains(index);
    if (isSelected)
      selectedIndices.remove(index);
    else
      selectedIndices.add(index);
    notifyListeners();
  }

  Future<void> updateTodayDeliveries(
      List<Subscription> newSubscriptions, Address address) async {
    newSubscriptions = newSubscriptions
        .map((subscription) => subscription
          ..deliveredTimestamp = DateTime.now().millisecondsSinceEpoch
          ..address =
              "${address.houseNo}, ${address.colony}, ${address.city}, ${address.state} - ${address.pincode}")
        .toList();

    await deliveries.addAll(newSubscriptions);
    // todayDeliveries.addAll(newSubscriptions);
    notifyListeners();
  }

  Future<bool> postDeliveryDetails(List<Subscription> subscriptions,
      Address address, XFile capturedImage) async {
    // Clear selected indices
    selectedIndices.clear();
    final DeliveryAgent deliveryAgent =
        Hive.box<DeliveryAgent>(kDeliveryAgentBoxName).get(kDeliveryAgentKey)!;

    try {
      final deliveredPackages = [];
      for (final subscription in subscriptions)
        deliveredPackages.add({
          "net_weight": subscription.netWeight,
          "status": 1,
          "package": subscription.package,
          "user_id": subscription.userId,
          "timeStamp": DateFormat(kPostDateFormat).format(DateTime.now()),
          "delivered_by": deliveryAgent.name,
          "delivery_agent_mobile": deliveryAgent.mobile
        });

      final FormData formData = FormData.fromMap({
        'subscriptions': jsonEncode(deliveredPackages),
        'image': await MultipartFile.fromFile(capturedImage.path)
      });

      final dioClient = Dio();
      final response = await dioClient.post("$kBaseUrl/delivery/update", data: formData);

      if (response.statusCode == HttpStatus.ok) {
        (await SharedPreferences.getInstance()).setString(
            kLastDeliveredTimestamp,
            DateFormat(kPostDateFormat).format(DateTime.now()));
        await updateTodayDeliveries(subscriptions, address);
        return true;
      } else
        return false;
    } catch (e) {}
    return false;
  }

  Future<DeliveryAgent?> getDeliveryAgent({@required String? mobile}) async {
    try {
      final response =
          await http.get(Uri.parse("$kBaseUrl/delivery/agent/$mobile"));
      if (response.statusCode == HttpStatus.ok) {
        final DeliveryAgent deliveryAgent =
            DeliveryAgent.fromJson(jsonDecode(response.body));

        // Save agent to DB
        await Hive.box<DeliveryAgent>(kDeliveryAgentBoxName)
            .put(kDeliveryAgentKey, deliveryAgent);
        return deliveryAgent;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Subscriber?> getSubscriber(String id) async {
    try {
      final response = await http.get(Uri.parse('$kBaseUrl/user/id/$id'));
      if (response.statusCode == HttpStatus.ok)
        return Subscriber.fromJson(jsonDecode(response.body));
      else
        return null;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

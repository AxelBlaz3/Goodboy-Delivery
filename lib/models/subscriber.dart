import 'subscription.dart';

import 'address.dart';

class Subscriber {
  final String id;
  final String name;
  final String mobile;
  List<Address>? addresses = [];
  final String email;
  final String photo;
  final int status;
  List<Subscription>? subscriptions = [];
  String? uid;

  Subscriber(
      {required this.id,
      required this.name,
      required this.mobile,
      this.addresses,
      required this.email,
      required this.photo,
      required this.uid,
      required this.status,
      this.subscriptions});

  factory Subscriber.fromJson(Map<String, dynamic> json) {
    return Subscriber(
        id: json['_id'],
        uid: json['uid'],
        name: json['name'],
        mobile: json['mobile_number'],
        addresses: List<Address>.from(
            json['addresses'].map((address) => Address.fromJson(address))),
        email: json['email'],
        photo: json['photo'],
        status: int.parse(json['status'].toString()),
        subscriptions: List<Subscription>.from(json['subscriptions']
            .map((subscription) => Subscription.fromJson(subscription))));
  }
}

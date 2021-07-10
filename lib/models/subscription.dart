import 'package:hive/hive.dart';

part 'subscription.g.dart';

@HiveType(typeId: 0)
class Subscription extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? package;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? price;

  @HiveField(4)
  final String? userId;

  @HiveField(5)
  final String? startTimeStamp;

  @HiveField(6)
  final int? status;

  @HiveField(7)
  final int? quantity;

  @HiveField(8)
  final String? startDate;

  @HiveField(9)
  final String? netWeight;

  // Attribute used for displaying address in today's deliveries.
  // Not really is a part of Subscription model.
  @HiveField(10)
  String? address;

  // Attribute used for displaying delivered time in today's deliveries.
  // Not really is a part of Subscription model.
  @HiveField(11)
  int? deliveredTimestamp;

  Subscription(
      {required this.id,
      required this.package,
      required this.name,
      required this.quantity,
      required this.price,
      required this.userId,
      required this.startTimeStamp,
      required this.netWeight,
      required this.startDate,
      required this.status,
      this.address});

  Map toJson() => {
        'name': name,
        'package': package,
        'quantity': quantity,
        'price': price,
        'start_timestamp': startTimeStamp,
        'status': status,
        'start_date': startDate,
        'net_weight': netWeight,
      };

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
        id: json['_id']['\$oid'],
        package: json['package'],
        name: json['name'],
        price: json['price'],
        userId: json['user_id'],
        quantity: json['quantity'],
        netWeight: json['net_weight'],
        startDate: json['start_date'],
        startTimeStamp: json['start_timestamp'],
        status: json['status']);
  }
}

import 'package:hive/hive.dart';

part 'delivery_agent.g.dart';

@HiveType(typeId: 1)
class DeliveryAgent {
    DeliveryAgent({
        this.id,
        this.isDelivering,
        this.mobile,
        this.name,
    });

    @HiveField(0)
    Id? id;

    @HiveField(1)
    bool? isDelivering;

    @HiveField(2)
    String? mobile;

    @HiveField(3)
    String? name;

    factory DeliveryAgent.fromJson(Map<String, dynamic> json) => DeliveryAgent(
        id: Id.fromJson(json["_id"]),
        isDelivering: json["is_delivering"],
        mobile: json["mobile"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id?.toJson(),
        "is_delivering": isDelivering,
        "mobile": mobile,
        "name": name,
    };
}

@HiveType(typeId: 2)
class Id {
    Id({
        this.oid,
    });

    @HiveField(0)
    String? oid;

    factory Id.fromJson(Map<String, dynamic> json) => Id(
        oid: json["\u0024oid"],
    );

    Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
    };
}

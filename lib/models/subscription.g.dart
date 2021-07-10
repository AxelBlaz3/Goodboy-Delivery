// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 0;

  @override
  Subscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subscription(
      id: fields[0] as String?,
      package: fields[1] as String?,
      name: fields[2] as String?,
      quantity: fields[7] as int?,
      price: fields[3] as String?,
      userId: fields[4] as String?,
      startTimeStamp: fields[5] as String?,
      netWeight: fields[9] as String?,
      startDate: fields[8] as String?,
      status: fields[6] as int?,
      address: fields[10] as String?,
    )..deliveredTimestamp = fields[11] as int?;
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.package)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.startTimeStamp)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.quantity)
      ..writeByte(8)
      ..write(obj.startDate)
      ..writeByte(9)
      ..write(obj.netWeight)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.deliveredTimestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

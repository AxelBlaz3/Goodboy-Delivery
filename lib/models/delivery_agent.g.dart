// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_agent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryAgentAdapter extends TypeAdapter<DeliveryAgent> {
  @override
  final int typeId = 1;

  @override
  DeliveryAgent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryAgent(
      id: fields[0] as Id?,
      isDelivering: fields[1] as bool?,
      mobile: fields[2] as String?,
      name: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryAgent obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isDelivering)
      ..writeByte(2)
      ..write(obj.mobile)
      ..writeByte(3)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryAgentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IdAdapter extends TypeAdapter<Id> {
  @override
  final int typeId = 2;

  @override
  Id read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Id(
      oid: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Id obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.oid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

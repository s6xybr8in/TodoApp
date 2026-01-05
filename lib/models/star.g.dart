// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'star.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StarAdapter extends TypeAdapter<Star> {
  @override
  final int typeId = 3;

  @override
  Star read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Star(
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Star obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

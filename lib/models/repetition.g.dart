// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repetition.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepetitionAdapter extends TypeAdapter<Repetition> {
  @override
  final int typeId = 4;

  @override
  Repetition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Repetition(
      id: fields[0] as String,
      type: fields[1] as RepeatType,
      interval: fields[2] as int,
      daysOfWeek: (fields[3] as List?)?.cast<int>(),
      endDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Repetition obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.interval)
      ..writeByte(3)
      ..write(obj.daysOfWeek)
      ..writeByte(4)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepetitionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepeatTypeAdapter extends TypeAdapter<RepeatType> {
  @override
  final int typeId = 3;

  @override
  RepeatType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RepeatType.daily;
      case 1:
        return RepeatType.weekly;
      case 2:
        return RepeatType.monthly;
      case 3:
        return RepeatType.yearly;
      default:
        return RepeatType.daily;
    }
  }

  @override
  void write(BinaryWriter writer, RepeatType obj) {
    switch (obj) {
      case RepeatType.daily:
        writer.writeByte(0);
        break;
      case RepeatType.weekly:
        writer.writeByte(1);
        break;
      case RepeatType.monthly:
        writer.writeByte(2);
        break;
      case RepeatType.yearly:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

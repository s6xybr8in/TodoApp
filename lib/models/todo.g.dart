// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 0;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      id: fields[0] as String,
      title: fields[2] as String,
      importance: fields[7] as Importance,
      progress: fields[4] as double,
      startDate: fields[8] as DateTime,
      endDate: fields[9] as DateTime,
      status: fields[6] as TodoStatus,
      childrenIds: (fields[1] as List?)?.cast<String>(),
      category: fields[11] as String?,
      isStared: fields[5] as bool,
      repetitionId: fields[12] as String?,
      checkedDate: fields[10] as DateTime?,
      parentId: fields[13] as String?,
      completeCount: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.childrenIds)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.completeCount)
      ..writeByte(4)
      ..write(obj.progress)
      ..writeByte(5)
      ..write(obj.isStared)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.importance)
      ..writeByte(8)
      ..write(obj.startDate)
      ..writeByte(9)
      ..write(obj.endDate)
      ..writeByte(10)
      ..write(obj.checkedDate)
      ..writeByte(11)
      ..write(obj.category)
      ..writeByte(12)
      ..write(obj.repetitionId)
      ..writeByte(13)
      ..write(obj.parentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

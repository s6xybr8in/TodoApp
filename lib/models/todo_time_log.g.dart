// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_time_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoTimeLogAdapter extends TypeAdapter<TodoTimeLog> {
  @override
  final int typeId = 5;

  @override
  TodoTimeLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoTimeLog(
      id: fields[0] as String,
      todoId: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TodoTimeLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.todoId)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoTimeLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

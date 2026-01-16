// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoStatusAdapter extends TypeAdapter<TodoStatus> {
  @override
  final int typeId = 2;

  @override
  TodoStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TodoStatus.active;
      case 1:
        return TodoStatus.done;
      case 2:
        return TodoStatus.deferred;
      case 3:
        return TodoStatus.failed;
      case 4:
        return TodoStatus.insufficient;
      default:
        return TodoStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, TodoStatus obj) {
    switch (obj) {
      case TodoStatus.active:
        writer.writeByte(0);
        break;
      case TodoStatus.done:
        writer.writeByte(1);
        break;
      case TodoStatus.deferred:
        writer.writeByte(2);
        break;
      case TodoStatus.failed:
        writer.writeByte(3);
        break;
      case TodoStatus.insufficient:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

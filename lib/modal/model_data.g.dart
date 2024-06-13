// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelClassAdapter extends TypeAdapter<ModelClass> {
  @override
  final int typeId = 0;

  @override
  ModelClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelClass(
      username: fields[0] as String,
      passwork: fields[2] as String,
      value: fields[1] as int,
      value2: fields[3] as int,
      email: fields[4] as String,
      value3: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ModelClass obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.passwork)
      ..writeByte(3)
      ..write(obj.value2)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.value3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

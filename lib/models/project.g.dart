// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 0;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      rating: fields[3] as double,
      interactions: fields[4] as int,
      unit: fields[5] as String,
      status: fields[6] as String,
      isNew: fields[7] as bool,
      isFavorited: fields[8] as bool,
      responsibleArea: fields[9] as String,
      responsiblePerson: fields[10] as String,
      technology: fields[11] as String,
      description: fields[12] as String,
      estimatedCompletionDate: fields[13] as DateTime,
      criticalDate: fields[14] as DateTime,
      ownerUserId: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.interactions)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.isNew)
      ..writeByte(8)
      ..write(obj.isFavorited)
      ..writeByte(9)
      ..write(obj.responsibleArea)
      ..writeByte(10)
      ..write(obj.responsiblePerson)
      ..writeByte(11)
      ..write(obj.technology)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.estimatedCompletionDate)
      ..writeByte(14)
      ..write(obj.criticalDate)
      ..writeByte(15)
      ..write(obj.ownerUserId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

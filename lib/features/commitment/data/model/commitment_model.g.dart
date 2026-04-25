// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commitment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommitmentModelAdapter extends TypeAdapter<CommitmentModel> {
  @override
  final int typeId = 0;

  @override
  CommitmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommitmentModel(
      id: fields[0] as String,
      category: fields[1] as String,
      plannedDuration: fields[2] as int,
      actualDuration: fields[3] as int?,
      penaltyAmount: fields[4] as int,
      restrictionLevel: fields[5] as String,
      blockedCategories: (fields[6] as List).cast<String>(),
      startTime: fields[7] as DateTime,
      endTime: fields[8] as DateTime?,
      isCompleted: fields[9] as bool,
      isActive: fields[10] as bool,
      createdAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CommitmentModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.plannedDuration)
      ..writeByte(3)
      ..write(obj.actualDuration)
      ..writeByte(4)
      ..write(obj.penaltyAmount)
      ..writeByte(5)
      ..write(obj.restrictionLevel)
      ..writeByte(6)
      ..write(obj.blockedCategories)
      ..writeByte(7)
      ..write(obj.startTime)
      ..writeByte(8)
      ..write(obj.endTime)
      ..writeByte(9)
      ..write(obj.isCompleted)
      ..writeByte(10)
      ..write(obj.isActive)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommitmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

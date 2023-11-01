// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_helper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  final int typeId = 0;

  @override
  Question read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Question(
      fields[0] as String,
      (fields[1] as List).cast<String>(),
      fields[2] as int,
      selectedOptionIndex: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.questionText)
      ..writeByte(1)
      ..write(obj.options)
      ..writeByte(2)
      ..write(obj.correctOptionIndex)
      ..writeByte(3)
      ..write(obj.selectedOptionIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

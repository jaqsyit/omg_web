import 'package:hive/hive.dart';

part 'hive_helper.g.dart';

@HiveType(typeId: 0)
class Question {
  @HiveField(0)
  final String questionText;

  @HiveField(1)
  final List<String> options;

  @HiveField(2)
  final int correctOptionIndex;

  @HiveField(3)
  int selectedOptionIndex;

  Question(this.questionText, this.options, this.correctOptionIndex,
      {this.selectedOptionIndex = -1});
}
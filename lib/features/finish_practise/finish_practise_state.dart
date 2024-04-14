import 'package:omg/models/examing_data.dart';

abstract class FinishPractiseState {}

class FinishPractiseLoading extends FinishPractiseState {}

class FinishPractiseLoaded extends FinishPractiseState {
  ExamingData? data;
  int? currentIndex;
  Map<int, int>? selectedOptions;
  String? examTimer;

  FinishPractiseLoaded({this.data, this.currentIndex, this.selectedOptions, this.examTimer});

  FinishPractiseLoaded copyWith({
    ExamingData? newExamingData,
    int? newCurrentIndex,
    Map<int, int>? newSelectedOptions,
    String? newExamTime
  }) {
    return FinishPractiseLoaded(
      data: newExamingData ?? data,
      currentIndex: newCurrentIndex ?? currentIndex,
      selectedOptions: newSelectedOptions ?? selectedOptions,
      examTimer: newExamTime ?? examTimer
    );
  }
}

class FinishPractiseError extends FinishPractiseState {
  final String? errMsg;

  FinishPractiseError({this.errMsg});
}
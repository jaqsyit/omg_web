import 'package:omg/models/examing_data.dart';

abstract class FinishState {}

class FinishLoading extends FinishState {}

class FinishLoaded extends FinishState {
  ExamingData? data;
  int? currentIndex;
  Map<int, int>? selectedOptions;
  String? examTimer;

  FinishLoaded({this.data, this.currentIndex, this.selectedOptions, this.examTimer});

  FinishLoaded copyWith({
    ExamingData? newExamingData,
    int? newCurrentIndex,
    Map<int, int>? newSelectedOptions,
    String? newExamTime
  }) {
    return FinishLoaded(
      data: newExamingData ?? data,
      currentIndex: newCurrentIndex ?? currentIndex,
      selectedOptions: newSelectedOptions ?? selectedOptions,
      examTimer: newExamTime ?? examTimer
    );
  }
}

class FinishError extends FinishState {
  final String? errMsg;

  FinishError({this.errMsg});
}
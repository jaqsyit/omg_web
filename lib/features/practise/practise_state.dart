

import '../../models/examing_data.dart';

abstract class PractiseState {}

class PractiseLoading extends PractiseState {}

class PractiseLoaded extends PractiseState {
  ExamingData? data;
  int? currentIndex;
  Map<int, int>? selectedOptions;
  String? examTimer;

  PractiseLoaded({this.data, this.currentIndex, this.selectedOptions, this.examTimer});

  PractiseLoaded copyWith({
    ExamingData? newPractiseData,
    int? newCurrentIndex,
    Map<int, int>? newSelectedOptions,
    String? newExamTime
  }) {
    return PractiseLoaded(
      data: newPractiseData ?? data,
      currentIndex: newCurrentIndex ?? currentIndex,
      selectedOptions: newSelectedOptions ?? selectedOptions,
      examTimer: newExamTime ?? examTimer
    );
  }
}

class PractiseError extends PractiseState {
  final String? errMsg;

  PractiseError({this.errMsg});
}
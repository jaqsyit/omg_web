import 'dart:async';

import 'package:omg/models/examing_data.dart';

abstract class ExamingState {}

class ExamingLoading extends ExamingState {}

class ExamingLoaded extends ExamingState {
  ExamingData? data;
  int? currentIndex;
  Map<int, int>? selectedOptions;
  String? examTimer;

  ExamingLoaded({this.data, this.currentIndex, this.selectedOptions, this.examTimer});

  ExamingLoaded copyWith({
    ExamingData? newExamingData,
    int? newCurrentIndex,
    Map<int, int>? newSelectedOptions,
    String? newExamTime
  }) {
    return ExamingLoaded(
      data: newExamingData ?? data,
      currentIndex: newCurrentIndex ?? currentIndex,
      selectedOptions: newSelectedOptions ?? selectedOptions,
      examTimer: newExamTime ?? examTimer
    );
  }
}

class ExamingError extends ExamingState {
  final String? errMsg;

  ExamingError({this.errMsg});
}
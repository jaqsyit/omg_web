import 'package:omg/models/exam_data.dart';

abstract class ExamState {}

class ExamLoading extends ExamState {}

class ExamLoaded extends ExamState {
  final ExamData data;

  ExamLoaded({required this.data});

  // ExamData get profileData => null;
}

class ExamError extends ExamState {
  final String? errMsg;

  ExamError({this.errMsg});
}
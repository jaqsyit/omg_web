
import 'package:omg/models/examing_data.dart';

abstract class ExamingState {}

class ExamingLoading extends ExamingState {}

class ExamingLoaded extends ExamingState {
  final ExamingData data;

  ExamingLoaded({required this.data});

  // ExamingData get examingData => null;
}

class ExamingError extends ExamingState {
  final String? errMsg;

  ExamingError({this.errMsg});
}
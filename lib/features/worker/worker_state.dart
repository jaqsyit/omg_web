import 'package:omg/models/orgs_list_data.dart';

abstract class WorkerState {}

class WorkerLoading extends WorkerState {}

class WorkerLoaded extends WorkerState {
  final OrgsData data;

  WorkerLoaded({required this.data});

  // WorkerListData get profileData => null;
}

class WorkerError extends WorkerState {
  final String? errMsg;

  WorkerError({this.errMsg});
}

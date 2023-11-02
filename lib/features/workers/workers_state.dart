import 'package:omg/models/workers_list_data.dart';

abstract class WorkersState {}

class WorkersLoading extends WorkersState {}

class WorkersLoaded extends WorkersState {
  final WorkersListData data;

  WorkersLoaded({required this.data});

  // WorkersListData get profileData => null;
}

class WorkersError extends WorkersState {
  final String? errMsg;

  WorkersError({this.errMsg});
}
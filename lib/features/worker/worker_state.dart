

abstract class WorkerState {}

class WorkerLoading extends WorkerState {}

class WorkerLoaded extends WorkerState {
  // final WorkersListData data;

  // WorkerLoaded({required this.data});

  // WorkerListData get profileData => null;
}

class WorkerError extends WorkerState {
  final String? errMsg;

  WorkerError({this.errMsg});
}
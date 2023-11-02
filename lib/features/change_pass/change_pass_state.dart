import 'package:omg/models/change_pass.dart';

abstract class InfoState {}

class InfoLoading extends InfoState {}

class InfoLoaded extends InfoState {
  final ChangePassData data;

  InfoLoaded({required this.data});

  // InfoData get profileData => null;
}

class InfoError extends InfoState {
  final String? errMsg;

  InfoError({this.errMsg});
}

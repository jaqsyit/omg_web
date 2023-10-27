import 'package:omg/models/login_data.dart';

abstract class InfoState {}

class InfoLoading extends InfoState {}

class InfoLoaded extends InfoState {
  final LoginData data;

  InfoLoaded({required this.data});

  // InfoData get profileData => null;
}

class InfoError extends InfoState {
  final String? errMsg;

  InfoError({this.errMsg});
}

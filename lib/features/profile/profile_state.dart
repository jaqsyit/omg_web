
import 'package:omg/models/profile_data.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileData data;

  ProfileLoaded({required this.data});

  // ProfileData get profileData => null;
}

class ProfileError extends ProfileState {
  final String? errMsg;

  ProfileError({this.errMsg});
}
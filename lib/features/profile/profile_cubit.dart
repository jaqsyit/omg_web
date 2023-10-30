import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/login/login_screen.dart';
import 'package:omg/features/profile/profile_state.dart';
import 'package:omg/models/profile_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';
import 'package:omg/services/storage_helper.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final BuildContext context;
  ProfileCubit({required this.context}) : super(ProfileLoading());

  Future<void> getProfile() async {
    if (state is! ProfileLoading) {
      emit(ProfileLoading());
    }

    final response = await NetworkHelper().get(url: PROFILE_URL);

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      // print(decodedResponse);
      final ProfileData dataDecoded = ProfileData.fromJson(decodedResponse);

      emit(ProfileLoaded(data: dataDecoded));
    } else if (response is String) {
      emit(ProfileError(errMsg: response));
    } else {
      emit(ProfileError(errMsg: 'Unknown error!'));
    }
  }

  Future<void> logout() async {
    if (state is! ProfileLoading) {
      emit(ProfileLoading());
    }

    await NetworkHelper().get(url: LOGOUT_URL);

    StorageManager storage = StorageManager();
    storage.deleteTokens();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> newUser() async {
    if (state is! ProfileLoading) {
      emit(ProfileLoading());
    }

    final response = await NetworkHelper().get(url: PROFILE_URL);

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      // print(decodedResponse);
      final ProfileData dataDecoded = ProfileData.fromJson(decodedResponse);

      emit(ProfileLoaded(data: dataDecoded));
    } else if (response is String) {
      emit(ProfileError(errMsg: response));
    } else {
      emit(ProfileError(errMsg: 'Unknown error!'));
    }
  }
}

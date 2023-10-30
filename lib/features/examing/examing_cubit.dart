import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/login/login_screen.dart';
import 'package:omg/features/examing/examing_state.dart';
import 'package:omg/models/examing_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';
import 'package:omg/services/storage_helper.dart';

class ExamingCubit extends Cubit<ExamingState> {
  final BuildContext context;
  ExamingCubit({required this.context}) : super(ExamingLoading());

  Future<void> getExaming() async {
    if (state is! ExamingLoading) {
      emit(ExamingLoading());
    }

    final response = await NetworkHelper().get(url: PROFILE_URL);

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      // print(decodedResponse);
      final ExamingData dataDecoded = ExamingData.fromJson(decodedResponse);

      emit(ExamingLoaded(data: dataDecoded));
    } else if (response is String) {
      emit(ExamingError(errMsg: response));
    } else {
      emit(ExamingError(errMsg: 'Unknown error!'));
    }
  }

  Future<void> logout() async {
    if (state is! ExamingLoading) {
      emit(ExamingLoading());
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
    if (state is! ExamingLoading) {
      emit(ExamingLoading());
    }

    final response = await NetworkHelper().get(url: PROFILE_URL);

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      // print(decodedResponse);
      final ExamingData dataDecoded = ExamingData.fromJson(decodedResponse);

      emit(ExamingLoaded(data: dataDecoded));
    } else if (response is String) {
      emit(ExamingError(errMsg: response));
    } else {
      emit(ExamingError(errMsg: 'Unknown error!'));
    }
  }
}

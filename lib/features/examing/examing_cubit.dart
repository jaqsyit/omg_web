import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/examing/examing_state.dart';
import 'package:omg/models/examing_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';

class ExamingCubit extends Cubit<ExamingState> {
  final BuildContext context;
  ExamingCubit({required this.context}) : super(ExamingLoading());

  Future<void> getExaming() async {
    if (state is! ExamingLoading) {
      emit(ExamingLoading());
    }

    final response = await NetworkHelper()
        .post(url: START_URL, withToken: false, body: {'accessCode': '744021'});

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

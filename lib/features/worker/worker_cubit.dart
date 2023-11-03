import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/worker/worker_state.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';

class WorkerCubit extends Cubit<WorkerState> {
  final BuildContext context;
  WorkerCubit({required this.context}) : super(WorkerLoading());

  Future<void> createWorker() async {
    if (state is! WorkerLoading) {
      emit(WorkerLoading());
    }

    final response = await NetworkHelper().get(url: WORKERS_URL);

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      emit(WorkerLoaded());
    } else if (response is String) {
      emit(WorkerError(errMsg: response));
    } else {
      emit(WorkerError(errMsg: 'Unknown error!'));
    }
  }

  void loadedState(){
    emit(WorkerLoaded());
  }
}

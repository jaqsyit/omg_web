import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/workers/workers_state.dart';
import 'package:omg/models/workers_list_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';

class WorkersCubit extends Cubit<WorkersState> {
  final BuildContext context;
  WorkersCubit({required this.context}) : super(WorkersLoading());

  Future<void> getWorkers() async {
    if (state is! WorkersLoading) {
      emit(WorkersLoading());
    }

    final response = await NetworkHelper().get(url: WORKERS_URL);

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      // print(decodedResponse);
      final WorkersListData dataDecoded = WorkersListData.fromJson(decodedResponse);

      emit(WorkersLoaded(data: dataDecoded));
    } else if (response is String) {
      emit(WorkersError(errMsg: response));
    } else {
      emit(WorkersError(errMsg: 'Unknown error!'));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/worker/worker_state.dart';
import 'package:omg/models/orgs_list_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';

class WorkerCubit extends Cubit<WorkerState> {
  final BuildContext context;
  WorkerCubit({required this.context}) : super(WorkerLoading());

  Future<void> getOrgsList() async {
    if (state is! WorkerLoading) {
      emit(WorkerLoading());
    }

    final response = await NetworkHelper().get(url: ORGS_URL);

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      final OrgsData dataDecoded = OrgsData.fromJson(decodedResponse);

      print(dataDecoded.data.length);

      emit(WorkerLoaded(data: dataDecoded));
    } else if (response is String) {
      emit(WorkerError(errMsg: response));
    } else {
      emit(WorkerError(errMsg: 'Unknown error!'));
    }
  }

  Future<void> addNewWorker(
      {required String name,
      required String surname,
      required String lastname,
      required String idOrg,
      required String phoneNumber,
      required String work}) async {
    final response = await NetworkHelper().post(url: WORKERS_URL, body: {
      'surname': surname,
      'name': name,
      'lastname': lastname,
      'org_id': idOrg,
      'phone': phoneNumber,
      'job': work
    });

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      if (decodedResponse.containsKey('success')) {
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Дұрыс!'),
            content: const Text('Жаңа жұмысшы қосылды!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  // void loadedState(){
  //   emit(WorkerLoaded());
  // }
}

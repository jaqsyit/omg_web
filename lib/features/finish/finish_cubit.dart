import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/finish/finish_state.dart';
import 'package:omg/features/login/login_screen.dart';
import 'package:omg/models/end_data.dart';
import 'package:omg/models/examing_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';
import 'package:omg/services/storage_helper.dart';
import 'package:omg/widgets/loading_dialog.dart';

class FinishCubit extends Cubit<FinishState> {
  final BuildContext context;
  FinishCubit({required this.context}) : super(FinishLoading());

  Future<void> stopFinish(String accessCode) async {
    int resultOfCheck = await checkAnswers();
    final storage = StorageManager();
    accessCode = (await storage.getAccessCode())!;
     print('Result: $resultOfCheck');
     print('Access code: $accessCode');
    String requestString = await stopFinishRequest(resultOfCheck, accessCode);
    if (requestString == '1' || requestString == '0') {
      StorageManager storage = StorageManager();
      await storage.deleteUserStatus();
      await Hive.close();
      await Hive.deleteBoxFromDisk('questionsBox');
      await Hive.deleteBoxFromDisk('optionsBox');
      await Hive.deleteBoxFromDisk('correctOptionBox');
      await Hive.deleteBoxFromDisk('selectedOptionsBox');
      await Hive.deleteBoxFromDisk('timerBox').whenComplete(
        () => showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Емтихан аяқталды'),
            content: Text(
              'Сіз емтиханнан ${requestString == '1' ? 'өттіңіз' : 'құладыңыз'}',
              style: TextStyle(
                color: requestString == '1' ? Colors.green : Colors.red,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false,
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<int> checkAnswers() async {
    Box<int> selectedOptionsBox = await Hive.openBox<int>('selectedOptionsBox');
    Box<int> correctOptionBox = await Hive.openBox<int>('correctOptionBox');

    int numberOfCorrectAnswers = 0;

    for (var key in selectedOptionsBox.keys) {
      if (selectedOptionsBox.get(key) == correctOptionBox.get(key)) {
        numberOfCorrectAnswers++;
      }
    }

    return numberOfCorrectAnswers;
  }

  Future<String> stopFinishRequest(int resultOfCheck, String accessCode) async {
    String _result = '';
    LoadingDialog.show(context);
    final response =
        await NetworkHelper().post(url: END_URL, withToken: false, body: {
      'accessCode': accessCode,
      'started_at': '2023-10-20',
      'right_count': resultOfCheck.toString()
    }).whenComplete(() {
      LoadingDialog.hide(context);
    });

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);
      final EndData endData = EndData.fromJson(decodedResponse);
      if (decodedResponse.containsKey('success')) {
        _result = endData.questions.pass.toString();
      }
    } else if (response is String) {
      _result = response;
    }
    return _result;
  }

  Future<void> getFinish(String? accessCode,
      [ExamingData? examingData, Map<int, int>? selectedOptions]) async {
    if (this.isClosed) {
      return;
    }

    emit(FinishLoaded(data: examingData, selectedOptions: selectedOptions));
  }

  Future<void> _saveTimeToHive(int time) async {
    final timerBox = await Hive.openBox<int>('timerBox');
    timerBox.put('remainingTime', time);
  }

  void goToQuestion(currentIndex) {
    if (state is FinishLoaded) {
      FinishLoaded? currentState = state as FinishLoaded;
      emit(currentState.copyWith(newCurrentIndex: currentIndex));
    }
  }
}

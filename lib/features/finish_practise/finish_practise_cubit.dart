import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/login/login_screen.dart';
import 'package:omg/models/examing_data.dart';
import 'package:omg/services/storage_helper.dart';

import 'finish_practise_state.dart';

class FinishPractiseCubit extends Cubit<FinishPractiseState> {
  final BuildContext context;
  FinishPractiseCubit({required this.context}) : super(FinishPractiseLoading());

  Future<void> stopFinishPractise() async {
    int resultOfCheck = await checkAnswers();
    // final storage = StorageManager();
    print('Result: $resultOfCheck');

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
            'Сіз практикадан $resultOfCheck ұпай жинадыңыз',
            // style: TextStyle(
            //   color: requestString == '1' ? Colors.green : Colors.red,
            // ),
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

  Future<void> getFinishPractise(
      [ExamingData? examingData, Map<int, int>? selectedOptions]) async {
    if (this.isClosed) {
      return;
    }

    emit(FinishPractiseLoaded(
        data: examingData, selectedOptions: selectedOptions));
  }

  Future<void> _saveTimeToHive(int time) async {
    final timerBox = await Hive.openBox<int>('timerBox');
    timerBox.put('remainingTime', time);
  }

  void goToQuestion(currentIndex) {
    if (state is FinishPractiseLoaded) {
      FinishPractiseLoaded? currentState = state as FinishPractiseLoaded;
      emit(currentState.copyWith(newCurrentIndex: currentIndex));
    }
  }
}

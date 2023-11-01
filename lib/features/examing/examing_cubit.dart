import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/examing/examing_state.dart';
import 'package:omg/features/login/login_screen.dart';
import 'package:omg/models/end_data.dart';
import 'package:omg/models/examing_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';
import 'package:omg/services/storage_helper.dart';
import 'package:omg/widgets/loading_dialog.dart';

class ExamingCubit extends Cubit<ExamingState> {
  final BuildContext context;
  ExamingCubit({required this.context}) : super(ExamingLoading());

  late Timer _timer;
  int _duration = 0;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _duration--;
      if (_duration <= 0) {
        _timer.cancel();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Емтихан аяқталды'),
            content: const Text('Сізге берілген уақыт аяқталды'),
            actions: [
              TextButton(
                onPressed: () => stopExaming(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      _updateTime();
    });
  }

  void _updateTime() {
    final String minutesStr = (_duration ~/ 60).toString().padLeft(2, '0');
    final String secondsStr = (_duration % 60).toString().padLeft(2, '0');
    String formattedTime = "$minutesStr:$secondsStr";
    _saveTimeToHive(_duration);
    if (state is ExamingLoaded) {
      ExamingLoaded currentState = state as ExamingLoaded;
      emit(currentState.copyWith(newExamTime: formattedTime));
    }
  }

  Future<void> stopExaming() async {
    _timer.cancel();

    int resultOfCheck = await checkAnswers();

    String requestString = await stopExamingRequest(resultOfCheck);
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

  Future<String> stopExamingRequest(int resultOfCheck) async {
    String _result = '';
    LoadingDialog.show(context);
    final response =
        await NetworkHelper().post(url: END_URL, withToken: false, body: {
      'accessCode': '744021',
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

  Future<void> getExaming() async {
    if (state is! ExamingLoading) {
      emit(ExamingLoading());
    }

    Box<String> questionsBox;
    Box<List<dynamic>> optionsBox;
    Box<int> correctOptionBox;
    Box<int> selectedOptionsBox;

    if (!Hive.isBoxOpen('questionsBox')) {
      questionsBox = await Hive.openBox<String>('questionsBox');
    } else {
      questionsBox = Hive.box<String>('questionsBox');
    }

    if (!Hive.isBoxOpen('optionsBox')) {
      optionsBox = await Hive.openBox<List<dynamic>>('optionsBox');
    } else {
      optionsBox = Hive.box<List<dynamic>>('optionsBox');
    }

    if (!Hive.isBoxOpen('correctOptionBox')) {
      correctOptionBox = await Hive.openBox<int>('correctOptionBox');
    } else {
      correctOptionBox = Hive.box<int>('correctOptionBox');
    }

    if (!Hive.isBoxOpen('selectedOptionsBox')) {
      selectedOptionsBox = await Hive.openBox<int>('selectedOptionsBox');
    } else {
      selectedOptionsBox = Hive.box<int>('selectedOptionsBox');
    }

    if (questionsBox.isEmpty) {
      final response = await NetworkHelper().post(
          url: START_URL, withToken: false, body: {'accessCode': '744021'});

      if (response is Response) {
        final decodedResponse = JsonDecoder().responseToMap(response);
        final ExamingData dataDecoded = ExamingData.fromJson(decodedResponse);

        for (var i = 0; i < dataDecoded.questions.length; i++) {
          await questionsBox.put(i, dataDecoded.questions[i].question);
          await optionsBox.put(i, dataDecoded.questions[i].options);
          await correctOptionBox.put(i, dataDecoded.questions[i].correctOption);
        }

        emit(ExamingLoaded(data: dataDecoded));
        _duration = await _loadTimeFromHive() ?? _duration;
        startTimer();
      } else if (response is String) {
        emit(ExamingError(errMsg: response));
      } else {
        emit(ExamingError(errMsg: 'Unknown error!'));
      }
    } else {
      Map<int, int> loadedSelectedOptions =
          selectedOptionsBox.toMap().cast<int, int>();
      Map<dynamic, String> loadedQuestions = questionsBox.toMap();
      Map<dynamic, List<dynamic>> loadedOptions = optionsBox.toMap();
      Map<dynamic, int> loadedCorrectOptions = correctOptionBox.toMap();

      List<Question> loadedQuestionList = [];

      for (var i = 0; i < loadedQuestions.length; i++) {
        loadedQuestionList.add(Question(
            question: loadedQuestions[i]!,
            options: loadedOptions[i] ?? ['null', 'null', 'null', 'null'],
            correctOption: loadedCorrectOptions[i]!));
      }

      final ExamingData loadedData = ExamingData(
          success: "loaded_from_hive", questions: loadedQuestionList);
      emit(ExamingLoaded(
          data: loadedData, selectedOptions: loadedSelectedOptions));
      _duration = await _loadTimeFromHive() ?? _duration;
      startTimer();
    }
  }

  Future<void> _saveTimeToHive(int time) async {
    final timerBox = await Hive.openBox<int>('timerBox');
    timerBox.put('remainingTime', time);
  }

  Future<int?> _loadTimeFromHive() async {
    if (Hive.isBoxOpen('timerBox')) {
      final timerBox = Hive.box<int>('timerBox');
      return timerBox.get('remainingTime');
    } else {
      final timerBox = await Hive.openBox<int>('timerBox');
      return timerBox.get('remainingTime');
    }
  }

  void goToQuestion(currentIndex) {
    if (state is ExamingLoaded) {
      ExamingLoaded? currentState = state as ExamingLoaded;
      emit(currentState.copyWith(newCurrentIndex: currentIndex));
    }
  }

  void selectOption(int optionIndex, int questionIndex) async {
    if (state is ExamingLoaded) {
      ExamingLoaded currentState = state as ExamingLoaded;
      Map<int, int> updatedSelectedOptions =
          Map.of(currentState.selectedOptions ?? {});

      final selectedOptionsBox = await Hive.openBox<int>('selectedOptionsBox');
      await selectedOptionsBox.put(questionIndex, optionIndex);

      updatedSelectedOptions[questionIndex] = optionIndex;
      emit(currentState.copyWith(newSelectedOptions: updatedSelectedOptions));
    }
  }
}

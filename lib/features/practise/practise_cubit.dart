import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/models/end_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';
import 'package:omg/widgets/loading_dialog.dart';

import '../../models/examing_data.dart';
import '../finish_practise/finish_practise_screen.dart';
import 'practise_state.dart';

class PractiseCubit extends Cubit<PractiseState> {
  final BuildContext context;
  PractiseCubit({required this.context}) : super(PractiseLoading());

  // late Timer _timer;
  // int _duration = 0;

  // void startTimer(String accessCode, [ExamingData? practiseData]) {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     _duration--;
  //     if (_duration <= 0) {
  //       _timer.cancel();
  //       PractiseLoaded currentState = state as PractiseLoaded;
  //       Map<int, int>? selectedOptions = currentState.selectedOptions;
  //       showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Емтихан аяқталды'),
  //           content: const Text('Сізге берілген уақыт аяқталды'),
  //           actions: [
  //             TextButton(
  //               onPressed: () => stopPractise(practiseData, selectedOptions),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //     _updateTime();
  //   });
  // }

  // void _updateTime() {
  //   final String minutesStr = (_duration ~/ 60).toString().padLeft(2, '0');
  //   final String secondsStr = (_duration % 60).toString().padLeft(2, '0');
  //   String formattedTime = "$minutesStr:$secondsStr";
  //   _saveTimeToHive(_duration);
  //   if (state is PractiseLoaded) {
  //     PractiseLoaded currentState = state as PractiseLoaded;
  //     emit(currentState.copyWith(newExamTime: formattedTime));
  //   }
  // }

  void stopPractise(
      [ExamingData? practiseData,
      Map<int, int>? selectedOptions]) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => FinishPractiseScreen(
                examingData: practiseData,
                selectedOptions: selectedOptions,
              )),
    );
  }

  // Future<void> stopPractise(String accessCode) async {
  //   _timer.cancel();

  //   int resultOfCheck = await checkAnswers();

  //   String requestString = await stopPractiseRequest(resultOfCheck, accessCode);
  //   if (requestString == '1' || requestString == '0') {
  //     StorageManager storage = StorageManager();
  //     await storage.deleteUserStatus();
  //     await Hive.close();
  //     await Hive.deleteBoxFromDisk('questionsBox');
  //     await Hive.deleteBoxFromDisk('optionsBox');
  //     await Hive.deleteBoxFromDisk('correctOptionBox');
  //     await Hive.deleteBoxFromDisk('selectedOptionsBox');
  //     await Hive.deleteBoxFromDisk('timerBox').whenComplete(
  //       () => showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Емтихан аяқталды'),
  //           content: Text(
  //             'Сіз емтиханнан ${requestString == '1' ? 'өттіңіз' : 'құладыңыз'}',
  //             style: TextStyle(
  //               color: requestString == '1' ? Colors.green : Colors.red,
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => LoginScreen(),
  //                 ),
  //                 (route) => false,
  //               ),
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  // }

  // Future<int> checkAnswers() async {
  //   Box<int> selectedOptionsBox = await Hive.openBox<int>('selectedOptionsBox');
  //   Box<int> correctOptionBox = await Hive.openBox<int>('correctOptionBox');

  //   int numberOfCorrectAnswers = 0;

  //   for (var key in selectedOptionsBox.keys) {
  //     if (selectedOptionsBox.get(key) == correctOptionBox.get(key)) {
  //       numberOfCorrectAnswers++;
  //     }
  //   }

  //   return numberOfCorrectAnswers;
  // }

  Future<String> stopPractiseRequest(
      int resultOfCheck, String accessCode) async {
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

  Future<void> getPractise(language, subject, chin, quantity) async {
    if (state is! PractiseLoading) {
      emit(PractiseLoading());
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
      final response = await NetworkHelper()
          .post(url: PRACTISE_URL, withToken: false, body: {
        'subject': subject,
        'language': language,
        'quantity': quantity,
        'chin': chin,
      });

      if (response is Response) {
        final decodedResponse = JsonDecoder().responseToMap(response);
        final ExamingData dataDecoded = ExamingData.fromJson(decodedResponse);

        for (var i = 0; i < dataDecoded.questions.length; i++) {
          await questionsBox.put(i, dataDecoded.questions[i].question);
          await optionsBox.put(i, dataDecoded.questions[i].options);
          await correctOptionBox.put(i, dataDecoded.questions[i].correctOption);
        }

        emit(PractiseLoaded(data: dataDecoded));
        // _duration = await _loadTimeFromHive() ?? _duration;
        // startTimer(accessCode!);
      } else if (response is String) {
        emit(PractiseError(errMsg: response));
      } else {
        emit(PractiseError(errMsg: 'Unknown error!'));
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
      emit(PractiseLoaded(
          data: loadedData, selectedOptions: loadedSelectedOptions));
      // _duration = await _loadTimeFromHive() ?? _duration;
      // startTimer(accessCode!);
    }
  }

  // Future<void> _saveTimeToHive(int time) async {
  //   final timerBox = await Hive.openBox<int>('timerBox');
  //   timerBox.put('remainingTime', time);
  // }

  // Future<int?> _loadTimeFromHive() async {
  //   if (Hive.isBoxOpen('timerBox')) {
  //     final timerBox = Hive.box<int>('timerBox');
  //     return timerBox.get('remainingTime');
  //   } else {
  //     final timerBox = await Hive.openBox<int>('timerBox');
  //     return timerBox.get('remainingTime');
  //   }
  // }

  void goToQuestion(currentIndex) {
    if (state is PractiseLoaded) {
      PractiseLoaded? currentState = state as PractiseLoaded;
      emit(currentState.copyWith(newCurrentIndex: currentIndex));
    }
  }

  void selectOption(int optionIndex, int questionIndex) async {
    if (state is PractiseLoaded) {
      PractiseLoaded currentState = state as PractiseLoaded;
      Map<int, int> updatedSelectedOptions =
          Map.of(currentState.selectedOptions ?? {});

      final selectedOptionsBox = await Hive.openBox<int>('selectedOptionsBox');
      await selectedOptionsBox.put(questionIndex, optionIndex);

      updatedSelectedOptions[questionIndex] = optionIndex;
      emit(currentState.copyWith(newSelectedOptions: updatedSelectedOptions));
    }
  }
}

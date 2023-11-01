import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
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

      if (response is http.Response) {
        final decodedResponse = JsonDecoder().responseToMap(response);
        final ExamingData dataDecoded = ExamingData.fromJson(decodedResponse);

        for (var i = 0; i < dataDecoded.questions.length; i++) {
          await questionsBox.put(i, dataDecoded.questions[i].question);
          await optionsBox.put(i, dataDecoded.questions[i].options);
          await correctOptionBox.put(i, dataDecoded.questions[i].correctOption);
        }

        emit(ExamingLoaded(data: dataDecoded));
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

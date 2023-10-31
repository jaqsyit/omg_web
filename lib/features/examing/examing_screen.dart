import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/styles.dart';
import 'package:omg/features/examing/examing_cubit.dart';
import 'package:omg/features/examing/examing_state.dart';
import 'package:omg/widgets/error_column.dart';
import 'package:omg/widgets/loading_widget.dart';

class ExamingScreen extends StatefulWidget {
  const ExamingScreen({Key? key}) : super(key: key);

  @override
  _ExamingScreenState createState() => _ExamingScreenState();
}

class _ExamingScreenState extends State<ExamingScreen> {
  int currentIndex = 0;

  Map<int, int> selectedOptions = {};

  List<List<String>> answers = [];

  void goToNextQuestion() {
    setState(() {
      currentIndex++;
    });
  }

  void goToPreviousQuestion() {
    setState(() {
      currentIndex--;
    });
  }

  void goToQuestion(int questionIndex) {
    setState(() {
      currentIndex = questionIndex;
    });
  }

  void selectOption(int optionIndex) {
    setState(() {
      selectedOptions[currentIndex] = optionIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExamingCubit(context: context)..getExaming(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ExamingCubit, ExamingState>(
            builder: (context, state) {
              final examingCubit = BlocProvider.of<ExamingCubit>(context);
              if (state is ExamingLoading) {
                return const LoadingWidget();
              } else if (state is ExamingLoaded) {
                bool isFirstQuestion = currentIndex == 0;
                bool isLastQuestion =
                    currentIndex == state.data.questions.length - 1;
                return Container(
                  margin: const EdgeInsets.all(100),
                  child: Center(
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    for (int i = 0;
                                        i < state.data.questions.length;
                                        i++)
                                      ElevatedButton(
                                        onPressed: () {
                                          goToQuestion(i);
                                        },
                                        child: Text((i + 1).toString()),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                Text(
                                  'Сұрақ № ${currentIndex + 1}, барлығы ${state.data.questions.length}:',
                                  style: CustomTextStyles.questionTextStyle,
                                ),
                                Text(
                                  state.data.questions[currentIndex]
                                      .question, // Use currentIndex here
                                  style: CustomTextStyles.questionTextStyle,
                                ),
                                const SizedBox(height: 16.0),
                                SizedBox(
                                  height: 700,
                                  child: ListView.builder(
                                    itemCount: state.data
                                        .questions[currentIndex].options.length,
                                    itemBuilder: (context, i) {
                                      final answerText = state.data
                                          .questions[currentIndex].options[i];
                                      return ListTile(
                                        title: Text(
                                          answerText,
                                          style:
                                              CustomTextStyles.optionTextStyle,
                                        ),
                                        leading: Radio(
                                          value: i,
                                          groupValue: selectedOptions
                                                  .containsKey(currentIndex)
                                              ? selectedOptions[currentIndex]
                                              : null,
                                          onChanged: (int? value) {
                                            selectOption(value!);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16),
                            if (!isFirstQuestion)
                              ElevatedButton(
                                onPressed: goToPreviousQuestion,
                                child: const Text(
                                  'Артқа',
                                  style: CustomTextStyles.questionTextStyle,
                                ),
                              ),
                            const SizedBox(width: 16),
                            if (!isLastQuestion)
                              ElevatedButton(
                                onPressed: goToNextQuestion,
                                child: const Text(
                                  'Келесі',
                                  style: CustomTextStyles.questionTextStyle,
                                ),
                              ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              child: const Text(
                                'Аяқтау',
                                style: CustomTextStyles.questionTextStyle,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is ExamingError) {
                return ErrorColumn(
                  errMsg: state.errMsg,
                  onRetry: () async {
                    await examingCubit.getExaming();
                  },
                );
              } else {
                return const ErrorColumn();
              }
            },
          ),
        ),
      ),
    );
  }
}

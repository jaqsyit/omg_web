import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/styles.dart';
import 'package:omg/features/finish/finish_cubit.dart';
import 'package:omg/features/finish/finish_state.dart';
import 'package:omg/models/examing_data.dart';
import 'package:omg/widgets/error_column.dart';
import 'package:omg/widgets/loading_widget.dart';

class FinishScreen extends StatefulWidget {
  final String? accessCode;
  final ExamingData? examingData;
  final Map<int, int>? selectedOptions;
  FinishScreen(
      {Key? key, this.accessCode, this.examingData, this.selectedOptions})
      : super(key: key);

  @override
  FinishScreenState createState() => FinishScreenState();
}

class FinishScreenState extends State<FinishScreen> {
  List<List<String>> answers = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FinishCubit(context: context)
        ..getFinish(widget.accessCode ?? '', widget.examingData,
            widget.selectedOptions),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<FinishCubit, FinishState>(
            builder: (context, state) {
              final finishCubit = BlocProvider.of<FinishCubit>(context);
              if (state is FinishLoading) {
                return const LoadingWidget();
              } else if (state is FinishLoaded) {
                int questionIndex = state.currentIndex ?? 0;
                bool isFirstQuestion = questionIndex == 0;
                bool isLastQuestion =
                    questionIndex == state.data!.questions.length - 1;
                return Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                color: Colors.black12,
                                padding: const EdgeInsets.all(25),
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    for (int i = 0;
                                        i < state.data!.questions.length;
                                        i++)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: state.selectedOptions?[i] !=
                                                      null &&
                                                  state.selectedOptions![i]! >=
                                                      0
                                              ? state.selectedOptions![i] ==
                                                      state.data!.questions[i]
                                                          .correctOption
                                                  ? Colors.blue
                                                  : Colors.red
                                              : Colors.red,
                                          onPrimary: Colors.white,
                                          side: BorderSide(
                                            color: i == questionIndex
                                                ? Colors.blue
                                                : Colors.transparent,
                                            width: 5.0,
                                          ),
                                        ),
                                        onPressed: () {
                                          finishCubit.goToQuestion(i);
                                        },
                                        child: Text((i + 1).toString()),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Сұрақ № ${questionIndex + 1}, барлығы ${state.data!.questions.length}:',
                                      style: CustomTextStyles.questionTextStyle,
                                    ),
                                    Text(
                                      state.data!.questions[questionIndex]
                                          .question,
                                      style: CustomTextStyles.questionTextStyle,
                                    ),
                                    const SizedBox(height: 16.0),
                                    SizedBox(
                                      height: 700,
                                      child: ListView.builder(
                                        itemCount: state
                                            .data!
                                            .questions[questionIndex]
                                            .options
                                            .length,
                                        itemBuilder: (context, i) {
                                          final answerText = state
                                              .data!
                                              .questions[questionIndex]
                                              .options[i];
                                          bool isSelected =
                                              state.selectedOptions?[
                                                      questionIndex] ==
                                                  i;
                                          bool isCorrect = state
                                                  .data!
                                                  .questions[questionIndex]
                                                  .correctOption ==
                                              i;
                                          bool isIncorrectSelection = state
                                                          .selectedOptions?[
                                                      questionIndex] !=
                                                  null &&
                                              state
                                                      .data!
                                                      .questions[questionIndex]
                                                      .correctOption !=
                                                  state.selectedOptions![
                                                      questionIndex];
                                          Color containerColor;
                                          if (isSelected && isCorrect) {
                                            containerColor = Colors.blue;
                                          } else if (isSelected && !isCorrect) {
                                            containerColor = Colors.red;
                                          } else if (isCorrect &&
                                              isIncorrectSelection) {
                                            containerColor = Colors.blue;
                                          } else {
                                            containerColor = Colors.transparent;
                                          }
                                          return Container(
                                            color: containerColor,
                                            child: ListTile(
                                              title: Text(
                                                answerText,
                                                style: CustomTextStyles
                                                    .optionTextStyle,
                                              ),
                                              leading: Radio(
                                                value:
                                                    state.selectedOptions?[i] ??
                                                        i,
                                                groupValue: state
                                                            .selectedOptions !=
                                                        null
                                                    ? state.selectedOptions!
                                                            .containsKey(
                                                                questionIndex)
                                                        ? state.selectedOptions![
                                                            questionIndex]
                                                        : null
                                                    : null,
                                                onChanged: (int? value) {},
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black12,
                        padding: const EdgeInsets.all(25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 16),
                            if (!isFirstQuestion)
                              ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Colors.green),
                                ),
                                onPressed: () {
                                  questionIndex--;
                                  finishCubit.goToQuestion(questionIndex);
                                },
                                child: const Text(
                                  'Артқа',
                                  style: CustomTextStyles.questionTextStyle,
                                ),
                              ),
                            const SizedBox(width: 16),
                            if (!isLastQuestion)
                              ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Colors.green),
                                ),
                                onPressed: () {
                                  questionIndex++;
                                  finishCubit.goToQuestion(questionIndex);
                                },
                                child: const Text(
                                  'Келесі',
                                  style: CustomTextStyles.questionTextStyle,
                                ),
                              ),
                            const Spacer(),
                            Text(
                              state.examTimer != null
                                  ? state.examTimer.toString()
                                  : '--:--',
                              style: CustomTextStyles.s26w700cb,
                            ),
                            const SizedBox(width: 30),
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(Colors.red),
                              ),
                              child: const Text(
                                'Келісемін',
                                style: CustomTextStyles.questionTextStyle,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Растаңыз'),
                                    content: const Text(
                                        'Емтиханды аяқтау үшін ОК басыңыз'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await finishCubit
                                              .stopFinish(widget.accessCode ?? '');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is FinishError) {
                return ErrorColumn(
                  errMsg: state.errMsg,
                  onRetry: () async {
                    await finishCubit.getFinish(widget.accessCode ?? '');
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

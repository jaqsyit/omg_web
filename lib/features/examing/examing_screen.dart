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
  ExamingScreenState createState() => ExamingScreenState();
}

class ExamingScreenState extends State<ExamingScreen> {
  List<List<String>> answers = [];

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
                                          primary: state.selectedOptions?[i] != null &&
                                                  state.selectedOptions![i]! >= 0
                                              ? Colors.blue
                                              : Colors.grey,
                                          onPrimary: Colors.white,
                                          side: BorderSide(
                                            color: i == questionIndex
                                                ? Colors.blue
                                                : Colors.transparent,
                                            width: 5.0,
                                          ),
                                        ),
                                        onPressed: () {
                                          examingCubit.goToQuestion(i);
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
                                          .question, // Use questionIndex here
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
                                          return ListTile(
                                            title: Text(
                                              answerText,
                                              style: CustomTextStyles
                                                  .optionTextStyle,
                                            ),
                                            leading: Radio(
                                              value: i,
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
                                              onChanged: (int? value) {
                                                examingCubit.selectOption(
                                                    value!, questionIndex);
                                              },
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
                                  examingCubit.goToQuestion(questionIndex);
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
                                  examingCubit.goToQuestion(questionIndex);
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
                                'Аяқтау',
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
                                        onPressed: () =>
                                            examingCubit.stopExaming(),
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

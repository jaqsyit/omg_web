import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:omg/features/exam/exam_state.dart';
import 'package:omg/features/examing/examing_screen.dart';
import 'package:omg/models/exam_data.dart';
import 'package:omg/services/storage_helper.dart';

class ExamCubit extends Cubit<ExamState> {
  final BuildContext context;
  ExamData examData;
  ExamCubit({required this.context, required this.examData})
      : super(ExamLoading());

  Future<void> startExam(int accessCode,String lang) async {
    final timerBox = await Hive.openBox<int>('timerBox');
    int differenceInSeconds =
        examData.exam.group.end.difference(examData.exam.group.start).inSeconds;
    timerBox.put('remainingTime', differenceInSeconds);

    StorageManager storage = StorageManager();
    await storage.setUserStatus('examing').whenComplete(
          () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ExamingScreen(
                accessCode: accessCode.toString(),
                language: lang,
              ),
            ),
            (route) => false,
          ),
        );
  }
}

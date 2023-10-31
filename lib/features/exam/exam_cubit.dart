import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/exam/exam_state.dart';
import 'package:omg/features/examing/examing_screen.dart';
import 'package:omg/services/storage_helper.dart';

class ExamCubit extends Cubit<ExamState> {
  final BuildContext context;
  ExamCubit({required this.context}) : super(ExamLoading());

  Future<void> startExam() async {
    StorageManager storage = StorageManager();
    storage.setUserStatus('examing').whenComplete(
          () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => ExamingScreen(),
            ),
            (route) => false,
          ),
        );
  }
}

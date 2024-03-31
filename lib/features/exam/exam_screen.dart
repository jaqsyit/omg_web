import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/constants/styles.dart';
import 'package:omg/features/exam/exam_cubit.dart';
import 'package:omg/models/exam_data.dart';
import 'package:intl/intl.dart';
import 'package:omg/services/storage_helper.dart';

class ExamScreen extends StatelessWidget {
  final ExamData examData;

  const ExamScreen(this.examData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExamCubit(context: context, examData: examData),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${examData.exam.workers.surname} ${examData.exam.workers.name} ${examData.exam.workers.lastname}',
                      style: CustomTextStyles.s20w500cw,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${examData.exam.workers.org.nameKk} ${examData.exam.workers.job}',
                      style: CustomTextStyles.s18w500cw,
                    ),
                    Text(
                      '${examData.exam.group.subject} (${examData.exam.group.chin})',
                      style: CustomTextStyles.s18w500cw,
                    ),
                    Text(
                      examData.exam.group.commission,
                      style: CustomTextStyles.s18w500cw,
                    ),
                    Text(
                      DateFormat('HH:mm      dd.MM.yyyy')
                          .format(examData.exam.group.start),
                      style: CustomTextStyles.s18w500cw,
                    ),
                    Text(
                      DateFormat('HH:mm      dd.MM.yyyy')
                          .format(examData.exam.group.end),
                      style: CustomTextStyles.s18w500cw,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
              const Text('Ескертулер'),
              const SizedBox(height: 100),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      StorageManager storage = StorageManager();
                      await storage
                          .setAccessCode(examData.exam.accessCode.toString())
                          .whenComplete(
                        () {
                          ExamCubit(context: context, examData: examData)
                              .startExam(examData.exam.accessCode, 'kk');
                        },
                      );
                    },
                    child: const Text('Емтиханды бастау'),
                  ),
                  const SizedBox(width: 50),
                  ElevatedButton(
                    onPressed: () async {
                      StorageManager storage = StorageManager();
                      await storage
                          .setAccessCode(examData.exam.accessCode.toString())
                          .whenComplete(
                        () {
                          ExamCubit(context: context, examData: examData)
                              .startExam(examData.exam.accessCode, 'ru');
                        },
                      );
                    },
                    child: const Text('Начать экзамен'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

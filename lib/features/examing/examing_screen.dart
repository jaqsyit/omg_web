import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/examing/examing_cubit.dart';
import 'package:omg/features/examing/examing_state.dart';
import 'package:omg/models/exam_data.dart';
import 'package:omg/widgets/error_column.dart';
import 'package:omg/widgets/loading_widget.dart';

class ExamingScreen extends StatelessWidget {
  
  final ExamData examData;

  const ExamingScreen(this.examData, {Key? key}) : super(key: key);

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
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.blue],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(50),
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 900,
                      height: 600,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                          ],
                        ),
                      ),
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

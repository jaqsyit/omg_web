import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omg/features/exam/exam_state.dart';


class ExamCubit extends Cubit<ExamState> {
  final BuildContext context;
  ExamCubit({required this.context}) : super(ExamLoading());

  // Future<void> getExam() async {
  //   if(state is! ExamLoading) {
  //     emit(ExamLoading());
  //   }

  //   final response = await NetworkHelper(context: context).get(url: INFO_URL);

  //   if(response is Response) {
  //     final decodedResponse = JsonDecoder().responseToMap(response);

  //     // print(decodedResponse);
  //     final  ExamData dataDecoded =  ExamData.fromJson(decodedResponse);

  //     emit(ExamLoaded(data: dataDecoded));
  //   } else if (response is String){
  //     emit(ExamError(errMsg: response));
  //   } else {
  //     emit(ExamError(errMsg: 'Unknown error!'));
  //   }
  // }
}
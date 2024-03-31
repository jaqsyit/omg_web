import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/bottom/bottom_bar.dart';
import 'package:omg/features/exam/exam_screen.dart';
import 'package:omg/models/exam_data.dart';
import 'package:omg/models/login_data.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:omg/services/storage_helper.dart';
import 'package:omg/widgets/loading_dialog.dart';

import '../practice/practice_screen.dart';

class LoginCubit extends Cubit<bool> {
  final BuildContext context;
  LoginCubit({required this.context}) : super(false);

  Future<void> login({required String login, required String password}) async {
    LoadingDialog.show(context);
    final response = await NetworkHelper().post(
        url: LOGIN_URL,
        withToken: false,
        body: {'email': login, 'password': password}).whenComplete(() {
      LoadingDialog.hide(context);
    });

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      final LoginData loginData = LoginData.fromJson(decodedResponse);
      if (decodedResponse.containsKey('token')) {
        StorageManager storage = StorageManager();
        await storage.setUserStatus('kontingent');
        await storage.setToken(loginData.token).whenComplete(
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainBar(),
                ),
                (route) => false,
              ),
            );
      }
    } else if (response is String) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Қате'),
          content: Text(response),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> startTest({required String code}) async {
    LoadingDialog.show(context);
    final response = await NetworkHelper().post(
        url: CHECK_CODE,
        withToken: false,
        body: {'access_code': code}).whenComplete(() {
      LoadingDialog.hide(context);
    });

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

      final ExamData examData = ExamData.fromJson(decodedResponse);

      if (decodedResponse.containsKey('exam')) {
        if (!context.mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Тексеріңіз!'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                      '${examData.exam.workers.surname} ${examData.exam.workers.name}'),
                  Text(examData.exam.group.subject),
                  Text(examData.exam.group.chin),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text(
                  'Мен емес',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamScreen(examData),
                  ),
                  (route) => false,
                ),
                child: const Text('Иә'),
              ),
            ],
          ),
        );
      }
    } else if (response is String) {
      // final snackBar = SnackBar(content: Text(response));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Қате'),
          content: Text(response),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> startPractice() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => PracticeScreen(),
      ),
      (route) => false,
    );
  }

  void enableAutoValidate() {
    if (!state) {
      emit(true);
    }
  }
}

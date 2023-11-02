import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:omg/constants/urls.dart';
import 'package:omg/features/login/login_screen.dart';
import 'package:omg/models/change_pass.dart';
import 'package:omg/services/json_decoder.dart';
import 'package:omg/services/network_helper.dart';
import 'package:flutter/material.dart';
import 'package:omg/widgets/loading_dialog.dart';

class ChangePassCubit extends Cubit<bool> {
  final BuildContext context;
  ChangePassCubit({required this.context}) : super(false);

  Future<void> changePass(
      {required String login,
      required String password,
      required String newPassword}) async {
    LoadingDialog.show(context);
    final response = await NetworkHelper().post(
        url: LOGIN_URL,
        withToken: false,
        body: {
          'email': login,
          'password': password,
          'new_password': newPassword
        }).whenComplete(() {
      LoadingDialog.hide(context);
    });

    if (response is Response) {
      final decodedResponse = JsonDecoder().responseToMap(response);

       ChangePassData.fromJson(decodedResponse);
      if (decodedResponse.containsKey('profile')) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false,
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

  void enableAutoValidate() {
    if (!state) {
      emit(true);
    }
  }
}

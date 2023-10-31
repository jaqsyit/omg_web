import 'package:flutter/material.dart';
import 'package:omg/features/examing/examing_screen.dart';
import 'package:omg/features/login/login_screen.dart';
import 'package:omg/features/profile/profile_screen.dart';
import 'package:omg/services/storage_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final StorageManager storage = StorageManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Коорпоративтік оқу орталығы',
      home: FutureBuilder<String?>(
        future: storage.getUserStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == 'kontingent') {
              return ProfileScreen();
            } else if (snapshot.data == 'examing') {
              return ExamingScreen();
            }
            return LoginScreen();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

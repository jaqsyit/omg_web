import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:omg/features/bottom/bottom_bar.dart';
import 'package:omg/features/examing/examing_screen.dart';
import 'package:omg/features/login/login_screen.dart';
import 'package:omg/services/hive_helper.dart';
import 'package:omg/services/storage_helper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(QuestionAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final StorageManager storage = StorageManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Корпоративтік оқу орталығы',
      home: FutureBuilder<String?>(
        future: storage.getUserStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == 'kontingent') {
              return const MainBar();
            } else if (snapshot.data == 'examing') {
              return ExamingScreen();
            }
            return LoginScreen();
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

//    scp -R C:\dev\omg\build\web\* ubuntu@omg-koo.kz:/var/www/html/public
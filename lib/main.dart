import 'package:chat_app/DB%20Manager/database_halper.dart';
import 'package:chat_app/home_page.dart';
import 'package:chat_app/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAWBJUy-Iv599acmCICx-Wugep4Yk2OYpY",
          appId: "1:318033192837:android:96ff97822759f330dd06ec",
          messagingSenderId: "318033192837",
          projectId: "chat-app-2f3c9"));
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (DBHelper.auth.currentUser == null) {
      debugPrint("no user exist !!! ");
    } else {
      debugPrint(DBHelper.auth.currentUser.toString());
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DBHelper.auth.currentUser == null
          ? const LoginScreen()
          : const HomePage(),
    );
  }
}

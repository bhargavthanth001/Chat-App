import 'package:chat_app/DB%20Manager/database_halper.dart';
import 'package:chat_app/google_sign_in.dart';
import 'package:chat_app/home_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: height / 20,
              ),
              Image.asset(
                "assets/group-talking-icon-blue.png",
                height: height / 3.2,
                width: width / 0.7,
              ),
              SizedBox(
                height: height / 28,
              ),
              const Text(
                "Flutter Chat",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(
                height: height / 10,
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hey There \nWelcome Back",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                  Text(
                    "login to your account to continue",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: height / 8,
              ),
              const Spacer(),
              MaterialButton(
                height: height / 16,
                minWidth: double.infinity,
                onPressed: () async {
                  SignIn.siginWithGoogle().then((value) {
                    DBHelper.createUser();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(style: BorderStyle.solid),
                ),
                child: ListTile(
                  leading: Image.asset(
                    "assets/google_logo.png",
                    height: height / 40,
                    width: width / 9,
                  ),
                  title: const Text(
                    "Sign in with Google",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

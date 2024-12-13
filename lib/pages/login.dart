import 'package:flutter/material.dart';
import 'package:my_doggo_app/forms/login_form.dart';
import 'package:my_doggo_app/pages/home.dart';
import 'package:my_doggo_app/pages/register.dart';
import 'package:my_doggo_app/secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPage> {
  void isUserLoggedIn() async {
    String? token = await SecureStorage().readToken();
    bool isUserLoggedIn =  token == null ? false : true;
    if (isUserLoggedIn) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    isUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginForm(),
          GestureDetector(
            onTap: () => {
              Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      )
            },
            child:  const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                "Register",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.w500
                ),
              ),

            )
          )
        ],
      )
    );
  }
}
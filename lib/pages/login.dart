import 'package:flutter/material.dart';
import 'package:my_doggo_app/forms/login_form.dart';
import 'package:my_doggo_app/pages/register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
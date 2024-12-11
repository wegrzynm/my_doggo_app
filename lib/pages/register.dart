import 'package:flutter/material.dart';
import 'package:my_doggo_app/forms/register_form.dart';
import 'package:my_doggo_app/pages/home.dart';
import 'package:my_doggo_app/pages/login.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, MaterialPageRoute(builder: (context) => const LoginPage())),
      body: ListView(
        children: const [
          RegisterForm()
        ],
      )
      );
  }
}
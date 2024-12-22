import 'package:flutter/material.dart';
import 'dart:convert'; 
import 'package:my_doggo_app/api_utils.dart';
import 'package:my_doggo_app/environment.dart';
import 'package:my_doggo_app/pages/login.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    const String url = '${Environment.apiUrl}register';
    final Map<String, String> body = {
      'email': _emailController.text,
      'password': _passwordController.text,
      'name': _nameController.text,
      'lastname': _lastnameController.text,
    };

    var response = await ApiUtils.postRequest(url,body, false);
    var (statusCode, apiResponse) = response;

    if (statusCode == 201) {
      final Map<String, dynamic> data = json.decode(apiResponse);
      final String msg = data['message'];

      // Navigate or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      final Map<String, dynamic> errorData = json.decode(apiResponse);
      setState(() {
        _errorMessage = errorData['error'] ?? 'An error occurred.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 10, 15, 10),
              child: TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.start,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                  hintText: "Name",
                  hintStyle: const TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 30,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 10),
              child: TextFormField(
                controller: _lastnameController,
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.start,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                  hintText: "Lastname",
                  hintStyle: const TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 30,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your lastname';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 10),
              child: TextFormField(
                controller: _emailController,
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.start,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                  hintText: "email@example.com",
                  hintStyle: const TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 30,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 10),
              child: TextFormField(
                controller: _passwordController,
                textAlign: TextAlign.start,
                obscureText: true,
                style: const TextStyle(fontSize: 30),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                  hintText: "Password",
                  hintStyle: const TextStyle(
                    color: Color(0xffDDDADA),
                    fontSize: 30,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 10),
              child: SizedBox(
                width: double.infinity, // Full width button
                height: 60, // Bigger height
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit"),
                ),
              ),
            ),
          ],
        ),
    );
  }
}

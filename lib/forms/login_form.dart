import 'package:flutter/material.dart';
import 'package:my_doggo_app/api_utils.dart';
import 'package:my_doggo_app/environment.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:my_doggo_app/pages/home.dart';
import 'package:my_doggo_app/secure_storage.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    const String url = '${Environment.apiUrl}login';
    final Map<String, String> body = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    var response = await ApiUtils.postRequest(url,body, false);
    var (statusCode, apiResponse) = response;

    if (statusCode == 200) {
      final Map<String, dynamic> data = json.decode(apiResponse);
        final String token = data['token'];

        // Save the token securely
        SecureStorage().writeSecureData('token', token);
        SecureStorage().writeSecureData('login', _emailController.text);
        SecureStorage().writeSecureData('password', _passwordController.text);

        // Navigate or show success message
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        setState(() {
          _isLoading = false;
        });
    } else {
      final Map<String, dynamic> errorData = json.decode(apiResponse);
      setState(() {
        _errorMessage = errorData['error'] ?? 'An error occurred.';
        _isLoading = false;
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
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _emailController,
              style: const TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
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
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _passwordController,
              textAlign: TextAlign.center,
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
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity, // Full width button
              height: 60, // Bigger height
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 24), // Bigger text
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

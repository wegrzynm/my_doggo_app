import 'package:flutter/material.dart';

class VetPage extends StatefulWidget {
  final int userId;
  const VetPage({super.key, required this.userId});

  @override
  State<VetPage> createState() => _VetPage();
}

class _VetPage extends State<VetPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Vets"),
    );
  }
}
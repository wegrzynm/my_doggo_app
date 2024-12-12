import 'package:flutter/material.dart';
import 'package:my_doggo_app/pages/home.dart';

class MemoriesPage extends StatefulWidget {
  final int userId;
  const MemoriesPage({super.key, required this.userId});

  @override
  State<MemoriesPage> createState() => _MemoriesPage();
}

class _MemoriesPage extends State<MemoriesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, MaterialPageRoute(builder: (context) => const HomePage())),
      body: Text("Memories"),
    );
  }
}
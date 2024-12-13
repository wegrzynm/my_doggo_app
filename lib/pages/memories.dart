import 'package:flutter/material.dart';

class MemoriesPage extends StatefulWidget {
  final int userId;
  const MemoriesPage({super.key, required this.userId});

  @override
  State<MemoriesPage> createState() => _MemoriesPage();
}

class _MemoriesPage extends State<MemoriesPage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Memories"),
    );
  }
}
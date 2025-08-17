import 'package:flutter/material.dart';

class SmartLock extends StatelessWidget {
  const SmartLock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SmartLock")),
      body: const Center(
        child: Text(
          "SmartLock",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SirineDarurat extends StatelessWidget {
  const SirineDarurat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SirineDarurat")),
      body: const Center(
        child: Text(
          "SirineDarurat",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

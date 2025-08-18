import 'package:flutter/material.dart';

class SirineDarurat extends StatelessWidget {
  const SirineDarurat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sirine Darurat")),
      body: const Center(
        child: Text(
          "Sirine Darurat",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

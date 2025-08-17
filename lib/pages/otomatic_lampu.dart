import 'package:flutter/material.dart';

class OtomaticLampu extends StatelessWidget {
  const OtomaticLampu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Otomatic Lampu")),
      body: const Center(
        child: Text(
          "Otomatic Lampu",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

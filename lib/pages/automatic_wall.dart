import 'package:flutter/material.dart';

class AutomaticWall extends StatelessWidget {
  const AutomaticWall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Automatic Wall")),
      body: const Center(
        child: Text(
          "Automatic Wall",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SensorGerak extends StatelessWidget {
  const SensorGerak({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensor Gerak")),
      body: const Center(
        child: Text(
          "Sensor Gerak",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

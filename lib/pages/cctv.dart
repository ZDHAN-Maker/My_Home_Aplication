import 'package:flutter/material.dart';

class CCTVPage extends StatelessWidget {
  const CCTVPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CCTV")),
      body: const Center(
        child: Text(
          "Halaman CCTV",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

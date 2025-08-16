import 'package:flutter/material.dart';

class StatusAirPage extends StatefulWidget {
  const StatusAirPage({super.key});

  @override
  State<StatusAirPage> createState() => _StatusAirPageState();
}

class _StatusAirPageState extends State<StatusAirPage> {
  double persentaseAir = 0.6; // 0.0 = habis, 1.0 = full

  String getStatusAir() {
    if (persentaseAir == 0) return "Habis";
    if (persentaseAir > 0 && persentaseAir <= 0.5) return "Setengah";
    return "Full";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Status Air')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Level Air: ${getStatusAir()}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: persentaseAir,
              minHeight: 30,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                persentaseAir <= 0.5 ? Colors.orange : Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Contoh simulasi isi/kurangi air
                setState(() {
                  persentaseAir += 0.1;
                  if (persentaseAir > 1) persentaseAir = 0;
                });
              },
              child: const Text("Update Level Air"),
            )
          ],
        ),
      ),
    );
  }
}

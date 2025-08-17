import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class StatusAirPage extends StatefulWidget {
  const StatusAirPage({super.key});

  @override
  State<StatusAirPage> createState() => _StatusAirPageState();
}

class _StatusAirPageState extends State<StatusAirPage> {
  // Definisi tema warna futuristik
  final Color primaryColor = const Color(0xFF0D1B2A);
  final Color secondaryColor = const Color(0xFF1B263B);
  final Color accentColor = const Color(0xFF415A77);
  final Color highlightColor = const Color(0xFF778DA9);
  final Color textColor = Colors.white;
  final Color accentBlue = Colors.cyanAccent;

  double persentaseAir = 0.6; // default sementara
  bool isLoading = false;

  String getStatusAir() {
    if (persentaseAir == 0) return "Habis";
    if (persentaseAir > 0 && persentaseAir <= 0.5) return "Setengah";
    return "Full";
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse("http://example.com/api/air")); //api dummy dan sedang menunggu sensor 

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          persentaseAir = (data["persentase"] ?? 0.0).toDouble();
        });
      } else {
        debugPrint("Menunggu API aktif... (status: ${response.statusCode})");
      }
    } catch (e) {
      debugPrint("Menunggu API aktif... ($e)");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text('Status Air', style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: secondaryColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Level Air: ${getStatusAir()}",
              style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: highlightColor, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: LinearProgressIndicator(
                  value: persentaseAir,
                  minHeight: 30,
                  backgroundColor: secondaryColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    persentaseAir <= 0.5 ? Colors.orange : accentBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator(color: Colors.cyanAccent)
            else
              ElevatedButton(
                onPressed: fetchData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentBlue,
                  foregroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Update dari API",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

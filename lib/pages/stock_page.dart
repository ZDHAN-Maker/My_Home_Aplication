import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<Map<String, dynamic>> stocks = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  DateTime selectedMonth = DateTime.now();
  DateTime? selectedDate;

  // Definisi tema warna futuristik
  final Color primaryColor = const Color(0xFF0D1B2A);
  final Color secondaryColor = const Color(0xFF1B263B);
  final Color accentColor = const Color(0xFF415A77);
  final Color highlightColor = const Color(0xFF778DA9);
  final Color textColor = Colors.white;
  final Color accentBlue = Colors.cyanAccent;

  @override
  void initState() {
    super.initState();
    loadStocks();
  }

  Future<File> getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/stocks.json");
  }

  Future<void> loadStocks() async {
    try {
      final file = await getLocalFile();
      if (await file.exists()) {
        final data = jsonDecode(await file.readAsString());
        setState(() {
          stocks = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (e) {
      debugPrint("Error load: $e");
    }
  }

  Future<void> saveStocks() async {
    try {
      final file = await getLocalFile();
      await file.writeAsString(jsonEncode(stocks));
    } catch (e) {
      debugPrint("Error save: $e");
    }
  }

  Future<void> exportToCSV() async {
    try {
      String content = "Tanggal,Nama,Jumlah\n";
      for (var item in stocks) {
        if (item['month'] == selectedMonth.month &&
            item['year'] == selectedMonth.year) {
          content +=
              "${item['date']},${item['name']},${item['qty']}\n";
        }
      }
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
          "${dir.path}/stok_${selectedMonth.month}_${selectedMonth.year}.csv");
      await file.writeAsString(content);
      // Menggunakan dialog kustom sebagai pengganti snackbar
      _showCustomDialog("Berhasil diekspor", "File CSV disimpan di ${file.path}");
    } catch (e) {
      _showCustomDialog("Gagal ekspor", "Terjadi kesalahan saat ekspor: $e");
    }
  }

  void addStock() {
    if (nameController.text.isNotEmpty &&
        qtyController.text.isNotEmpty &&
        selectedDate != null) {
      setState(() {
        stocks.add({
          "name": nameController.text,
          "qty": int.tryParse(qtyController.text) ?? 0,
          "date": "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
          "month": selectedDate!.month,
          "year": selectedDate!.year
        });
      });
      saveStocks();
      nameController.clear();
      qtyController.clear();
      selectedDate = null;
    }
  }

  void changeMonth(int change) {
    setState(() {
      selectedMonth =
          DateTime(selectedMonth.year, selectedMonth.month + change, 1);
    });
  }

  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: accentBlue,
              onPrimary: primaryColor,
              surface: secondaryColor,
              onSurface: textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: accentBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showCustomDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: accentBlue.withOpacity(0.5)),
        ),
        title: Text(
          title,
          style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.bold),
        ),
        content: Text(
          content,
          style: GoogleFonts.montserrat(color: highlightColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.montserrat(color: accentBlue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filtered = stocks
        .where((item) =>
            item['month'] == selectedMonth.month &&
            item['year'] == selectedMonth.year)
        .toList();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text("Stok Makanan", style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: secondaryColor,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(Icons.download, color: accentBlue),
            onPressed: exportToCSV,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: accentBlue),
                  onPressed: () => changeMonth(-1),
                ),
                Text(
                  "${selectedMonth.month}-${selectedMonth.year}",
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: accentBlue),
                  onPressed: () => changeMonth(1),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    style: GoogleFonts.montserrat(color: textColor),
                    cursorColor: accentBlue,
                    decoration: InputDecoration(
                      labelText: "Nama Makanan",
                      labelStyle: GoogleFonts.montserrat(color: highlightColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: highlightColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyanAccent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: qtyController,
                    style: GoogleFonts.montserrat(color: textColor),
                    cursorColor: accentBlue,
                    decoration: InputDecoration(
                      labelText: "Jumlah",
                      labelStyle: GoogleFonts.montserrat(color: highlightColor),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: highlightColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyanAccent),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: accentBlue),
                  onPressed: pickDate,
                ),
                IconButton(
                  icon: Icon(Icons.add, color: accentBlue),
                  onPressed: addStock,
                ),
              ],
            ),
          ),
          if (selectedDate != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Tanggal dipilih: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                style: GoogleFonts.montserrat(color: accentBlue),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                var item = filtered[index];
                return ListTile(
                  title: Text(item['name'], style: GoogleFonts.montserrat(color: textColor)),
                  subtitle: Text("Jumlah: ${item['qty']} (Tanggal: ${item['date']})",
                      style: GoogleFonts.montserrat(color: highlightColor)),
                  trailing: item['qty'] < 5
                      ? Text("Restock!",
                          style: GoogleFonts.montserrat(color: Colors.redAccent, fontWeight: FontWeight.bold))
                      : Text("Cukup",
                          style: GoogleFonts.montserrat(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                  tileColor: secondaryColor.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: highlightColor.withOpacity(0.2)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minVerticalPadding: 10,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

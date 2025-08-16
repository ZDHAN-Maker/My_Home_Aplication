import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> exportToTxt() async {
    try {
      String content = "Stok Bulan ${selectedMonth.month}-${selectedMonth.year}\n";
      for (var item in stocks) {
        content += "${item['name']} - ${item['qty']}\n";
      }
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/stok_${selectedMonth.month}_${selectedMonth.year}.txt");
      await file.writeAsString(content);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil diekspor: ${file.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal ekspor: $e")),
      );
    }
  }

  void addStock() {
    if (nameController.text.isNotEmpty && qtyController.text.isNotEmpty) {
      setState(() {
        stocks.add({
          "name": nameController.text,
          "qty": int.tryParse(qtyController.text) ?? 0,
          "month": selectedMonth.month,
          "year": selectedMonth.year
        });
      });
      nameController.clear();
      qtyController.clear();
    }
  }

  void changeMonth(int change) {
    setState(() {
      selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + change, 1);
      stocks = []; // Kosongkan atau ambil dari database jika ada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stok Makanan"),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: exportToTxt,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => changeMonth(-1),
              ),
              Text(
                "${selectedMonth.month}-${selectedMonth.year}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => changeMonth(1),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Nama Makanan"),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: qtyController,
                    decoration: InputDecoration(labelText: "Jumlah"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addStock,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stocks.length,
              itemBuilder: (context, index) {
                var item = stocks[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text("Jumlah: ${item['qty']}"),
                  trailing: item['qty'] < 5
                      ? Text("Restock!", style: TextStyle(color: Colors.red))
                      : Text("Cukup", style: TextStyle(color: Colors.green)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

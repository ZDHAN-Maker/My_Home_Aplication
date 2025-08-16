import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import './keamanan_page.dart';
import './status_air_page.dart';
import './stock_page.dart';
import './jadwal_page.dart';
import './login_page.dart';

/// ------------------- Tab Menu Utama -------------------
class HomeMenuTab extends StatefulWidget {
  final List<Map<String, dynamic>> cards;
  const HomeMenuTab({super.key, required this.cards});

  @override
  State<HomeMenuTab> createState() => _HomeMenuTabState();
}

class _HomeMenuTabState extends State<HomeMenuTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.cards.length,
      itemBuilder: (context, index) {
        final card = widget.cards[index];
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => card['page']),
                );
              },
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: const Color(0xFF415a77),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(card['icon'], size: 40, color: Colors.white),
                      const SizedBox(width: 16),
                      Text(
                        card['title'],
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

/// ------------------- Halaman Home -------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  File? _capturedImage;
  final picker = ImagePicker();

  final List<Map<String, dynamic>> _cards = [
    {'title': 'Keamanan', 'icon': Icons.security, 'page': const KeamananPage()},
    {'title': 'Status Air', 'icon': Icons.water, 'page': const StatusAirPage()},
    {'title': 'Stok', 'icon': Icons.inventory, 'page': const StockPage()},
    {'title': 'Jadwal', 'icon': Icons.schedule, 'page': const JadwalPage()},
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeMenuTab(cards: _cards),
      const Center(
        child: Text(
          'Halaman Lain',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    ];
  }

  Future<void> _openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _capturedImage = File(pickedFile.path);
      });

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Foto Berhasil Diambil'),
          content: Image.file(_capturedImage!),
          actions: [
            TextButton(
              child: const Text('Tutup'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0d1b2a),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              _selectedIndex == 0 ? 'MyHome' : 'Menu Lain',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            backgroundColor: const Color(0xFF1b263b),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0d1b2a), Color(0xFF1b263b)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: IndexedStack(index: _selectedIndex, children: _pages),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _openCamera,
            backgroundColor: Colors.cyan,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF1b263b),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.white),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on, color: Colors.white),
                label: 'Location',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.cyanAccent,
            unselectedItemColor: Colors.white70,
            selectedLabelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
            ),
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}

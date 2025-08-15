import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import './keamanan_page.dart';
import './status_air_page.dart';
import './stock_page.dart';
import './jadwal_page.dart';
import './login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const SizedBox.shrink(),
    Center(
      child: Text(
        'Halaman Lain',
        style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Map<String, dynamic>> _cards = [
    {'title': 'Keamanan', 'icon': Icons.security, 'page': const KeamananPage()},
    {'title': 'Status Air', 'icon': Icons.water, 'page': const StatusAirPage()},
    {'title': 'Stok', 'icon': Icons.inventory, 'page': const StockPage()},
    {'title': 'Jadwal', 'icon': Icons.schedule, 'page': const JadwalPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const SizedBox.shrink();
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              _selectedIndex == 0 ? 'Home' : 'Menu Lain',
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
            child: _selectedIndex == 0
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => card['page'],
                                ),
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
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      card['icon'],
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 10),
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
                  )
                : _pages[_selectedIndex],
          ),

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color(0xFF1b263b),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home, color: Colors.white),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.location_on, color: Colors.white),
                label: 'Location',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.cyanAccent,
            unselectedItemColor: Colors.white70,
            selectedLabelStyle:
                GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                GoogleFonts.montserrat(fontWeight: FontWeight.w500),
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}

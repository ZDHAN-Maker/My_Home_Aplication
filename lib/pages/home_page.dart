import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Import halaman baru (buat file baru untuk masing-masing halaman)
import './keamanan_page.dart';
import './status_air_page.dart';
import './stock_page.dart';
import './jadwal_page.dart';
import './login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState(); 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Selamat datang di Home Page!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List halaman untuk navbar
  final List<Widget> _pages = [
    const SizedBox.shrink(), // Kita akan render card di body
    const Center(child: Text('Halaman Lain', style: TextStyle(fontSize: 20))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List data card
  final List<Map<String, dynamic>> _cards = [
    {
      'title': 'Keamanan',
      'icon': Icons.security,
      'page': const KeamananPage(),
    },
    {
      'title': 'Status Air',
      'icon': Icons.water,
      'page': const StatusAirPage(),
    },
    {
      'title': 'Stok',
      'icon': Icons.inventory,
      'page': const StockPage(),
    },
    {
      'title': 'Jadwal',
      'icon': Icons.schedule,
      'page': const JadwalPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Kalau belum login
        if (!snapshot.hasData) {
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const SizedBox.shrink();
        }

        // Kalau sudah login
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _selectedIndex == 0 ? 'Home' : 'Menu Lain',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
          body: _selectedIndex == 0
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
                                  builder: (context) => card['page']),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.white,
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(card['icon'],
                                      size: 40, color: Colors.blue),
                                  const SizedBox(height: 10),
                                  Text(
                                    card['title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
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
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/home.png')),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('assets/icons/marker.png')),
                label: 'Location',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}

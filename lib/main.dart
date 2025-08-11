import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmanga/features/browse/presentation/screens/browse_screen.dart';
import 'package:gmanga/features/extensions/presentation/screens/extension_screen.dart';
import 'package:gmanga/features/library/presentation/screens/library_screen.dart';
import 'package:gmanga/features/manga_detail/presentation/screens/manga_detail_screen.dart';
import 'package:gmanga/features/reader/presentation/screens/manga_reader_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GManga',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
      routes: {
        '/extensions': (context) => const ExtensionScreen(),
        '/browse': (context) => const BrowseScreen(),
        '/library': (context) => const LibraryScreen(),
        '/manga': (context) => const MangaDetailScreen(),
        '/reader': (context) => const MangaReaderScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const BrowseScreen(),
    const LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
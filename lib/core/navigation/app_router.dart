import 'package:gmanga/features/extensions/presentation/screens/extension_screen.dart';
import 'package:gmanga/features/history/presentation/screens/reading_history_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:gmanga/features/browse/presentation/screens/browse_screen.dart';
import 'package:gmanga/features/manga_detail/presentation/screens/manga_detail_screen.dart';
import 'package:gmanga/features/library/presentation/screens/library_screen.dart';
import 'package:gmanga/features/reader/presentation/screens/manga_reader_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter/material.dart';

// This line connects this file to the generated code containing 'RouterRef'.
part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/browse',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/browse',
            builder: (context, state) => const BrowseScreen(),
          ),
          GoRoute(
            path: '/library',
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const ReadingHistoryScreen(),
          ),
          GoRoute(
            path: '/extensions',
            builder: (context, state) => const ExtensionScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/manga/:mangaId',
        builder: (context, state) {
          final mangaId = state.pathParameters['mangaId']!;
          return MangaDetailScreen(mangaId: mangaId);
        },
      ),
      GoRoute(
        path: '/manga/:mangaId/chapter/:chapterId',
        builder: (context, state) {
          final mangaId = state.pathParameters['mangaId']!;
          final encodedChapterId = state.pathParameters['chapterId']!;
          final mangaTitle = state.uri.queryParameters['mangaTitle'];
          return MangaReaderScreen(
            chapterId: encodedChapterId, // Pass encoded ID, will be decoded in the screen
            mangaTitle: mangaTitle,
          );
        },
      ),
      GoRoute(
        path: '/reader/:chapterId',
        builder: (context, state) {
          final encodedChapterId = state.pathParameters['chapterId']!;
          final mangaTitle = state.uri.queryParameters['mangaTitle'];
          return MangaReaderScreen(
            chapterId: encodedChapterId, // Pass encoded ID, will be decoded in the screen
            mangaTitle: mangaTitle,
          );
        },
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;
  
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Required for 4+ items
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              GoRouter.of(context).go('/browse');
              break;
            case 1:
              GoRouter.of(context).go('/library');
              break;
            case 2:
              GoRouter.of(context).go('/history');
              break;
            case 3:
              GoRouter.of(context).go('/extensions');
              break;
          }
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
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.extension),
            label: 'Extensions',
          ),
        ],
      ),
    );
  }
}

import 'package:gmanga/features/extensions/presentation/screens/extension_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:gmanga/features/browse/presentation/screens/browse_screen.dart';
import 'package:gmanga/features/browse/presentation/screens/manga_details_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;

// This line connects this file to the generated code containing 'RouterRef'.
part 'app_router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const BrowseScreen()),
      GoRoute(
        path: '/manga/:mangaId',
        builder: (context, state) {
          // Getting the mangaId parameter from the URL
          final mangaId = state.pathParameters['mangaId']!;
          return MangaDetailsScreen(mangaId: mangaId);
        },
      ),
      GoRoute(
        path: '/extensions',
        builder: (context, state) => const ExtensionScreen(),
      ),
    ],
  );
}

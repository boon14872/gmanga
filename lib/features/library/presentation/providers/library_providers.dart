import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/library_manga.dart';

// Library state management
final libraryProvider = StateNotifierProvider<LibraryNotifier, List<LibraryManga>>((ref) {
  return LibraryNotifier();
});

class LibraryNotifier extends StateNotifier<List<LibraryManga>> {
  LibraryNotifier() : super([]);

  void addManga(String id, String title, String thumbnailUrl, {String? author, String? status}) {
    print('LibraryNotifier: Adding manga - ID: $id, Title: $title');
    
    // Check if manga already exists
    if (state.any((manga) => manga.id == id)) {
      print('LibraryNotifier: Manga already exists in library');
      return;
    }

    final newManga = LibraryManga(
      id: id,
      title: title,
      thumbnailUrl: thumbnailUrl,
      author: author,
      status: status,
      addedDate: DateTime.now(),
    );

    state = [...state, newManga];
    print('LibraryNotifier: Manga added successfully. Total count: ${state.length}');
  }

  void removeManga(String id) {
    print('LibraryNotifier: Removing manga - ID: $id');
    final countBefore = state.length;
    state = state.where((manga) => manga.id != id).toList();
    print('LibraryNotifier: Manga removed. Count before: $countBefore, after: ${state.length}');
  }

  void toggleFavorite(String id) {
    state = state.map((manga) {
      if (manga.id == id) {
        return manga.copyWith(isFavorite: !manga.isFavorite);
      }
      return manga;
    }).toList();
  }

  void updateLastReadChapter(String id, int chapterNumber) {
    state = state.map((manga) {
      if (manga.id == id) {
        return manga.copyWith(lastReadChapter: chapterNumber);
      }
      return manga;
    }).toList();
  }

  bool isMangaInLibrary(String id) {
    return state.any((manga) => manga.id == id);
  }

  List<LibraryManga> get favorites => state.where((manga) => manga.isFavorite).toList();
}

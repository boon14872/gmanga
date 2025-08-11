import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref, StateProvider;
// ลบ import ของ MockMangaRepository ออก
// import 'package:gmanga/features/browse/data/mock_manga_repository.dart';

// เพิ่ม import ของ JsMangaRepository เข้ามาแทน
import 'package:gmanga/features/browse/data/js_manga_repository.dart';
import 'package:gmanga/features/browse/domain/manga.dart';
import 'package:gmanga/features/browse/domain/manga_repository.dart';
import 'package:gmanga/features/browse/presentation/providers/source_providers.dart';

part 'manga_providers.g.dart';

@Riverpod(keepAlive: true)
MangaRepository mangaRepository(Ref ref) {
  // เปลี่ยนจาก Mock เป็น JsMangaRepository
  return JsMangaRepository();
}

// ... โค้ดส่วนที่เหลือของ Provider เหมือนเดิม ...
@riverpod
class BrowseSource extends _$BrowseSource {
  int _currentPage = 1;
  List<Manga> _allManga = [];
  bool _hasMorePages = true;

  @override
  Future<List<Manga>> build() async {
    _currentPage = 1;
    _allManga = [];
    _hasMorePages = true;
    
    final repository = ref.watch(mangaRepositoryProvider);
    final selectedSource = ref.watch(selectedSourceProvider);
    
    // Load first page
    final firstPageManga = await repository.getPopularManga(_currentPage, source: selectedSource);
    _allManga = firstPageManga;
    
    return _allManga;
  }

  bool get hasMorePages => _hasMorePages;

  Future<void> loadMore() async {
    if (!_hasMorePages) return;
    
    // Set loading state
    ref.read(loadingMoreProvider.notifier).state = true;
    _currentPage++;
    
    try {
      final repository = ref.read(mangaRepositoryProvider);
      final selectedSource = ref.read(selectedSourceProvider);
      
      final newManga = await repository.getPopularManga(_currentPage, source: selectedSource);
      
      if (newManga.isEmpty) {
        _hasMorePages = false;
      } else {
        _allManga = [..._allManga, ...newManga];
        // Trigger rebuild with new data
        state = AsyncValue.data(_allManga);
      }
    } catch (error) {
      _currentPage--; // Revert page number on error
      state = AsyncValue.error(error, StackTrace.current);
    } finally {
      ref.read(loadingMoreProvider.notifier).state = false;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Simple state provider for loading more indicator
final loadingMoreProvider = StateProvider<bool>((ref) => false);

@riverpod
Future<Manga> mangaDetails(Ref ref, String mangaId) {
  final repository = ref.watch(mangaRepositoryProvider);
  return repository.getMangaDetails(mangaId);
}

@riverpod
Future<List<Chapter>> chapterList(Ref ref, String mangaId) {
  final repository = ref.watch(mangaRepositoryProvider);
  return repository.getChapters(mangaId);
}
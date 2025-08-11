import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref, StateProvider;
// ลบ import ของ MockMangaRepository ออก
// import 'package:gmanga/features/browse/data/mock_manga_repository.dart';

// เพิ่ม import ของ JsMangaRepository เข้ามาแทน
import 'package:gmanga/features/browse/data/js_manga_repository.dart';
import 'package:gmanga/features/browse/domain/manga.dart';
import 'package:gmanga/features/browse/domain/manga_repository.dart';
import 'package:gmanga/features/browse/presentation/providers/source_providers.dart';
import 'package:gmanga/core/services/cache_service.dart';

part 'manga_providers.g.dart';

@Riverpod(keepAlive: true)
MangaRepository mangaRepository(Ref ref) {
  // เปลี่ยนจาก Mock เป็น JsMangaRepository
  return JsMangaRepository();
}

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return CacheService();
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
    final cache = ref.watch(cacheServiceProvider);
    
    // Try to get from cache first
    final cachedManga = await cache.getCachedMangaList(
      selectedSource.id, 
      'popular',
      page: _currentPage,
    );
    
    if (cachedManga.isNotEmpty) {
      // Convert cached manga back to domain models
      _allManga = cachedManga.map((cached) => Manga(
        id: cached.mangaId,
        title: cached.title,
        thumbnailUrl: cached.thumbnailUrl,
        author: cached.author,
        description: cached.description,
        genres: cached.genres,
        status: cached.status,
      )).toList();
      
      // Load fresh data in background
      _loadFreshData();
      return _allManga;
    }
    
    // Load first page from network
    final firstPageManga = await repository.getPopularManga(_currentPage, source: selectedSource);
    _allManga = firstPageManga;
    
    // Cache the results
    await cache.cacheMangaList(firstPageManga, selectedSource.id, 'popular', page: _currentPage);
    
    return _allManga;
  }

  Future<void> _loadFreshData() async {
    try {
      final repository = ref.read(mangaRepositoryProvider);
      final selectedSource = ref.read(selectedSourceProvider);
      final cache = ref.read(cacheServiceProvider);
      
      final freshManga = await repository.getPopularManga(_currentPage, source: selectedSource);
      
      // Update cache
      await cache.cacheMangaList(freshManga, selectedSource.id, 'popular', page: _currentPage);
      
      // Update state if data has changed
      _allManga = freshManga;
      state = AsyncValue.data(_allManga);
    } catch (e) {
      // Silently fail for background refresh
    }
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

// Browse mode provider (popular, latest)
final browseModeProvider = StateProvider<String>((ref) => 'popular');

// Latest manga provider
@riverpod
class LatestSource extends _$LatestSource {
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
    final cache = ref.watch(cacheServiceProvider);
    
    // Try to get from cache first
    final cachedManga = await cache.getCachedMangaList(
      selectedSource.id, 
      'latest',
      page: _currentPage,
    );
    
    if (cachedManga.isNotEmpty) {
      // Convert cached manga back to domain models
      _allManga = cachedManga.map((cached) => Manga(
        id: cached.mangaId,
        title: cached.title,
        thumbnailUrl: cached.thumbnailUrl,
        author: cached.author,
        description: cached.description,
        genres: cached.genres,
        status: cached.status,
      )).toList();
      
      // Load fresh data in background
      _loadFreshData();
      return _allManga;
    }
    
    // Load first page from network
    final firstPageManga = await repository.getLatestManga(_currentPage, source: selectedSource);
    _allManga = firstPageManga;
    
    // Cache the results
    await cache.cacheMangaList(firstPageManga, selectedSource.id, 'latest', page: _currentPage);
    
    return _allManga;
  }

  Future<void> _loadFreshData() async {
    try {
      final repository = ref.read(mangaRepositoryProvider);
      final selectedSource = ref.read(selectedSourceProvider);
      final cache = ref.read(cacheServiceProvider);
      
      final freshManga = await repository.getLatestManga(_currentPage, source: selectedSource);
      
      // Update cache
      await cache.cacheMangaList(freshManga, selectedSource.id, 'latest', page: _currentPage);
      
      // Update state if data has changed
      _allManga = freshManga;
      state = AsyncValue.data(_allManga);
    } catch (e) {
      // Silently fail for background refresh
    }
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
      final cache = ref.read(cacheServiceProvider);
      
      final newManga = await repository.getLatestManga(_currentPage, source: selectedSource);
      
      if (newManga.isEmpty) {
        _hasMorePages = false;
      } else {
        _allManga = [..._allManga, ...newManga];
        // Cache the new page
        await cache.cacheMangaList(newManga, selectedSource.id, 'latest', page: _currentPage);
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

// Search provider
@riverpod
class Search extends _$Search {
  @override
  Future<List<Manga>> build() async {
    return [];
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    
    try {
      final repository = ref.read(mangaRepositoryProvider);
      final selectedSource = ref.read(selectedSourceProvider);
      final cache = ref.read(cacheServiceProvider);
      
      // Try cache first
      final cachedResults = await cache.getCachedMangaList(
        selectedSource.id,
        'search',
        searchQuery: query,
      );
      
      if (cachedResults.isNotEmpty) {
        final mangaList = cachedResults.map((cached) => Manga(
          id: cached.mangaId,
          title: cached.title,
          thumbnailUrl: cached.thumbnailUrl,
          author: cached.author,
          description: cached.description,
          genres: cached.genres,
          status: cached.status,
        )).toList();
        
        state = AsyncValue.data(mangaList);
        return;
      }
      
      // Search from network
      final results = await repository.searchManga(query, source: selectedSource);
      
      // Cache results
      await cache.cacheMangaList(results, selectedSource.id, 'search', searchQuery: query);
      
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  void clear() {
    state = const AsyncValue.data([]);
  }
}
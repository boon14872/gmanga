import 'package:gmanga/features/browse/domain/manga.dart';
import 'package:gmanga/core/database/isar_service.dart';
import 'package:gmanga/core/database/models/cached_manga.dart';
import 'package:isar/isar.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  static CacheService get instance => _instance;
  
  CacheService._internal();
  
  /// Cache manga list with source and type information
  Future<void> cacheMangaList(
    String sourceId,
    String type, // 'popular', 'latest', 'search'
    List<Manga> mangaList, {
    int page = 1,
    String? searchQuery,
  }) async {
    try {
      final isar = await IsarService.instance.isar;
      
      // Create cache entries
      final cachedMangaList = <CachedManga>[];
      for (final manga in mangaList) {
        final cached = CachedManga();
        cached.mangaId = manga.id;
        cached.sourceId = sourceId;
        cached.title = manga.title;
        cached.thumbnailUrl = manga.thumbnailUrl;
        cached.author = manga.author;
        cached.description = manga.description;
        cached.genres = manga.genres ?? [];
        cached.status = manga.status;
        cached.cachedAt = DateTime.now();
        cached.lastUpdated = DateTime.now();
        cached.cacheType = type;
        cached.page = page;
        cached.searchQuery = searchQuery;
        
        cachedMangaList.add(cached);
      }
      
      // Store in database
      await isar.writeTxn(() async {
        // Simple approach: just add new entries (we'll handle duplicates later)
        await isar.cachedMangas.putAll(cachedMangaList);
      });
      
      print('Cached ${mangaList.length} manga items for $sourceId/$type/page:$page');
    } catch (e) {
      print('Error caching manga list: $e');
    }
  }
  
  /// Get cached manga list
  Future<List<Manga>?> getCachedMangaList(
    String sourceId,
    String type, {
    int page = 1,
    String? searchQuery,
  }) async {
    try {
      final isar = await IsarService.instance.isar;
      
      // Simple query: get all cached manga and filter in memory for now
      final allCachedManga = await isar.cachedMangas.where().build().findAll();
      
      // Filter in memory
      final matchingManga = allCachedManga.where((cached) {
        return cached.sourceId == sourceId && 
               cached.cacheType == type && 
               cached.page == page &&
               cached.searchQuery == searchQuery;
      }).toList();
      
      if (matchingManga.isEmpty) {
        print('No cached manga found for $sourceId/$type/page:$page');
        return null;
      }
      
      // Check if cache is still valid (less than 1 hour old)
      final now = DateTime.now();
      final isValid = matchingManga.every((cached) {
        final cacheAge = now.difference(cached.cachedAt).inMinutes;
        return cacheAge < 60; // 1 hour
      });
      
      if (!isValid) {
        print('Cache expired for $sourceId/$type/page:$page, clearing...');
        // Remove expired cache
        await isar.writeTxn(() async {
          await isar.cachedMangas.deleteAll(
            matchingManga.map((c) => c.id).toList(),
          );
        });
        return null;
      }
      
      // Convert back to manga objects
      final mangaList = matchingManga.map((cached) {
        return Manga(
          id: cached.mangaId,
          title: cached.title,
          thumbnailUrl: cached.thumbnailUrl,
          author: cached.author,
          description: cached.description,
          genres: cached.genres,
          status: cached.status,
        );
      }).toList();
      
      print('Retrieved ${mangaList.length} cached manga for $sourceId/$type/page:$page');
      return mangaList;
    } catch (e) {
      print('Error getting cached manga list: $e');
      return null;
    }
  }
  
  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    try {
      final isar = await IsarService.instance.isar;
      final now = DateTime.now();
      final oneDayAgo = now.subtract(const Duration(hours: 24));
      
      // Get all entries and filter in memory
      final allEntries = await isar.cachedMangas.where().build().findAll();
      final expiredEntries = allEntries.where((entry) {
        return entry.cachedAt.isBefore(oneDayAgo);
      }).toList();
      
      if (expiredEntries.isNotEmpty) {
        await isar.writeTxn(() async {
          await isar.cachedMangas.deleteAll(
            expiredEntries.map((e) => e.id).toList(),
          );
        });
        print('Cleared ${expiredEntries.length} expired cache entries');
      } else {
        print('No expired cache entries found');
      }
    } catch (e) {
      print('Error clearing expired cache: $e');
    }
  }
  
  /// Clear all cache
  Future<void> clearAllCache() async {
    try {
      final isar = await IsarService.instance.isar;
      await isar.writeTxn(() async {
        final count = await isar.cachedMangas.count();
        await isar.cachedMangas.clear();
        print('Cleared all $count cache entries');
      });
    } catch (e) {
      print('Error clearing all cache: $e');
    }
  }
  
  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final isar = await IsarService.instance.isar;
      final allEntries = await isar.cachedMangas.where().build().findAll();
      final now = DateTime.now();
      
      // Count entries by age in memory
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      final oneDayAgo = now.subtract(const Duration(hours: 24));
      
      final recentEntries = allEntries.where((entry) {
        return entry.cachedAt.isAfter(oneHourAgo);
      }).length;
          
      final oldEntries = allEntries.where((entry) {
        return entry.cachedAt.isBefore(oneDayAgo);
      }).length;
      
      return {
        'totalEntries': allEntries.length,
        'recentEntries': recentEntries,
        'oldEntries': oldEntries,
        'lastChecked': now.toIso8601String(),
      };
    } catch (e) {
      print('Error getting cache stats: $e');
      return {};
    }
  }
}

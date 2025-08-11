import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CachedManga {
  final String mangaId;
  final String sourceId;
  final String title;
  final String thumbnailUrl;
  final String? author;
  final String? description;
  final List<String> genres;
  final String? status;
  final DateTime cachedAt;
  final DateTime lastUpdated;
  final String cacheType;
  final String? searchQuery;
  final int page;

  CachedManga({
    required this.mangaId,
    required this.sourceId,
    required this.title,
    required this.thumbnailUrl,
    this.author,
    this.description,
    this.genres = const [],
    this.status,
    required this.cachedAt,
    required this.lastUpdated,
    required this.cacheType,
    this.searchQuery,
    this.page = 1,
  });

  Map<String, dynamic> toJson() => {
    'mangaId': mangaId,
    'sourceId': sourceId,
    'title': title,
    'thumbnailUrl': thumbnailUrl,
    'author': author,
    'description': description,
    'genres': genres,
    'status': status,
    'cachedAt': cachedAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'cacheType': cacheType,
    'searchQuery': searchQuery,
    'page': page,
  };

  factory CachedManga.fromJson(Map<String, dynamic> json) => CachedManga(
    mangaId: json['mangaId'],
    sourceId: json['sourceId'],
    title: json['title'],
    thumbnailUrl: json['thumbnailUrl'],
    author: json['author'],
    description: json['description'],
    genres: List<String>.from(json['genres'] ?? []),
    status: json['status'],
    cachedAt: DateTime.parse(json['cachedAt']),
    lastUpdated: DateTime.parse(json['lastUpdated']),
    cacheType: json['cacheType'],
    searchQuery: json['searchQuery'],
    page: json['page'] ?? 1,
  );
}

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();
  
  static const Duration cacheExpiration = Duration(hours: 6);
  static const Duration searchCacheExpiration = Duration(hours: 1);
  
  String _getCacheKey(String sourceId, String cacheType, {String? searchQuery, int page = 1}) {
    final key = 'cache_${sourceId}_${cacheType}_page${page}';
    return searchQuery != null ? '${key}_search_$searchQuery' : key;
  }
  
  Future<void> cacheMangaList(
    List<dynamic> mangaList,
    String sourceId,
    String cacheType, {
    String? searchQuery,
    int page = 1,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getCacheKey(sourceId, cacheType, searchQuery: searchQuery, page: page);
    
    final cachedManga = mangaList.map((manga) => CachedManga(
      mangaId: manga.id,
      sourceId: sourceId,
      title: manga.title,
      thumbnailUrl: manga.thumbnailUrl,
      author: manga.author,
      description: manga.description,
      genres: List<String>.from(manga.genres ?? []),
      status: manga.status,
      cachedAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      cacheType: cacheType,
      searchQuery: searchQuery,
      page: page,
    )).toList();
    
    final jsonList = cachedManga.map((m) => m.toJson()).toList();
    await prefs.setString(key, jsonEncode(jsonList));
    
    // Cache search suggestions
    if (cacheType == 'search' && searchQuery != null) {
      await _cacheSearchQuery(searchQuery);
    }
  }
  
  Future<List<CachedManga>> getCachedMangaList(
    String sourceId,
    String cacheType, {
    String? searchQuery,
    int page = 1,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getCacheKey(sourceId, cacheType, searchQuery: searchQuery, page: page);
    
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];
    
    try {
      final jsonList = jsonDecode(jsonString) as List;
      final cachedManga = jsonList.map((json) => CachedManga.fromJson(json)).toList();
      
      // Check if cache is still valid
      final cutoffTime = DateTime.now().subtract(cacheExpiration);
      return cachedManga.where((manga) => manga.cachedAt.isAfter(cutoffTime)).toList();
    } catch (e) {
      return [];
    }
  }
  
  Future<bool> isCacheValid(
    String sourceId,
    String cacheType, {
    String? searchQuery,
    int page = 1,
  }) async {
    final cached = await getCachedMangaList(
      sourceId,
      cacheType,
      searchQuery: searchQuery,
      page: page,
    );
    
    return cached.isNotEmpty;
  }
  
  Future<void> clearCache({String? sourceId, String? cacheType}) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith('cache_')) {
        if (sourceId != null && !key.contains(sourceId)) continue;
        if (cacheType != null && !key.contains(cacheType)) continue;
        await prefs.remove(key);
      }
    }
  }
  
  Future<void> clearExpiredCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('cache_')).toList();
    
    for (final key in keys) {
      final jsonString = prefs.getString(key);
      if (jsonString == null) continue;
      
      try {
        final jsonList = jsonDecode(jsonString) as List;
        if (jsonList.isEmpty) continue;
        
        final firstItem = CachedManga.fromJson(jsonList.first);
        final cutoffTime = DateTime.now().subtract(cacheExpiration);
        
        if (firstItem.cachedAt.isBefore(cutoffTime)) {
          await prefs.remove(key);
        }
      } catch (e) {
        await prefs.remove(key);
      }
    }
  }
  
  Future<void> _cacheSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'search_history';
    final existingQueries = prefs.getStringList(key) ?? [];
    
    if (!existingQueries.contains(query)) {
      existingQueries.insert(0, query);
      if (existingQueries.length > 20) {
        existingQueries.removeLast();
      }
      await prefs.setStringList(key, existingQueries);
    }
  }
  
  Future<List<String>> getSearchSuggestions(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final searchHistory = prefs.getStringList('search_history') ?? [];
    
    return searchHistory
        .where((q) => q.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();
  }
}

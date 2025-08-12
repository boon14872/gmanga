import 'package:isar/isar.dart';

part 'cached_manga.g.dart';

@collection
class CachedManga {
  Id id = Isar.autoIncrement;

  @Index()
  late String mangaId;

  @Index()
  late String sourceId;

  late String title;
  late String thumbnailUrl;
  
  String? author;
  String? description;
  
  late List<String> genres;
  
  String? status;
  
  @Index()
  late DateTime cachedAt;
  
  late DateTime lastUpdated;
  
  @Index()
  late String cacheType; // 'popular', 'latest', 'search'
  
  String? searchQuery;
  
  @Index()
  late int page;

  // Constructor
  CachedManga();

  // Helper constructor for creating from domain models
  CachedManga.fromManga({
    required String mangaId,
    required String sourceId,
    required String title,
    required String thumbnailUrl,
    String? author,
    String? description,
    List<String>? genres,
    String? status,
    required String cacheType,
    String? searchQuery,
    int page = 1,
  }) {
    this.mangaId = mangaId;
    this.sourceId = sourceId;
    this.title = title;
    this.thumbnailUrl = thumbnailUrl;
    this.author = author;
    this.description = description;
    this.genres = genres ?? [];
    this.status = status;
    this.cachedAt = DateTime.now();
    this.lastUpdated = DateTime.now();
    this.cacheType = cacheType;
    this.searchQuery = searchQuery;
    this.page = page;
  }

  // Convert to JSON-like data for compatibility
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

  // Check if cache is expired
  bool get isExpired {
    final expirationTime = cacheType == 'search' 
        ? const Duration(hours: 1)
        : const Duration(hours: 6);
    return DateTime.now().difference(cachedAt) > expirationTime;
  }
}

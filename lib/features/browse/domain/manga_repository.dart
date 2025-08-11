import 'package:gmanga/features/browse/domain/manga.dart';
import 'package:gmanga/features/browse/domain/manga_source.dart';

// Abstract class (Interface)
abstract class MangaRepository {
  Future<List<Manga>> getPopularManga(int page, {MangaSource? source});
  Future<List<Manga>> getLatestManga(int page, {MangaSource? source});
  Future<List<Manga>> searchManga(String query, {MangaSource? source, int page = 1});
  Future<Manga> getMangaDetails(String mangaId, {MangaSource? source});
  Future<List<Chapter>> getChapters(String mangaId, {MangaSource? source});
}
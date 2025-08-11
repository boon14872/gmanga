import 'package:gmanga/features/browse/domain/manga.dart';
import 'package:gmanga/features/browse/domain/manga_source.dart';

// Abstract class (Interface)
abstract class MangaRepository {
  Future<List<Manga>> getPopularManga(int page, {MangaSource? source});
  Future<Manga> getMangaDetails(String mangaId, {MangaSource? source});
  Future<List<Chapter>> getChapters(String mangaId, {MangaSource? source});
}
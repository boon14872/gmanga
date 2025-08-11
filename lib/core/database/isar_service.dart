import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/reading_history.dart';
import 'models/user_settings.dart';
import '../../features/extensions/data/isar_extension_source.dart';

class IsarService {
  static IsarService? _instance;
  static Isar? _isar;

  IsarService._();

  static IsarService get instance {
    _instance ??= IsarService._();
    return _instance!;
  }

  Future<Isar> get isar async {
    if (_isar != null) return _isar!;
    
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        ReadingHistorySchema,
        UserSettingsSchema,
        IsarExtensionSourceSchema,
      ],
      directory: dir.path,
      name: 'gmanga_db',
    );
    
    return _isar!;
  }

  // Reading History Methods
  Future<void> saveReadingProgress({
    required String mangaId,
    required String mangaTitle,
    required String chapterId,
    required String chapterTitle,
    required int currentPage,
    required int totalPages,
  }) async {
    final db = await isar;
    
    await db.writeTxn(() async {
      // Check if entry already exists
      final existingEntry = await db.readingHistorys
          .filter()
          .mangaIdEqualTo(mangaId)
          .chapterIdEqualTo(chapterId)
          .findFirst();

      if (existingEntry != null) {
        // Update existing entry
        existingEntry.currentPage = currentPage;
        existingEntry.totalPages = totalPages;
        existingEntry.lastReadAt = DateTime.now();
        await db.readingHistorys.put(existingEntry);
      } else {
        // Create new entry
        final newEntry = ReadingHistory()
          ..mangaId = mangaId
          ..mangaTitle = mangaTitle
          ..chapterId = chapterId
          ..chapterTitle = chapterTitle
          ..currentPage = currentPage
          ..totalPages = totalPages
          ..lastReadAt = DateTime.now();
        
        await db.readingHistorys.put(newEntry);
      }
    });
  }

  Future<ReadingHistory?> getReadingProgress(String mangaId, String chapterId) async {
    final db = await isar;
    
    return await db.readingHistorys
        .filter()
        .mangaIdEqualTo(mangaId)
        .chapterIdEqualTo(chapterId)
        .findFirst();
  }

  Future<List<ReadingHistory>> getReadingHistory({int limit = 100}) async {
    final db = await isar;
    
    return await db.readingHistorys
        .where()
        .sortByLastReadAtDesc()
        .limit(limit)
        .findAll();
  }

  Future<List<ReadingHistory>> getMangaHistory(String mangaId) async {
    final db = await isar;
    
    return await db.readingHistorys
        .filter()
        .mangaIdEqualTo(mangaId)
        .sortByLastReadAtDesc()
        .findAll();
  }

  Future<void> deleteReadingHistory(int id) async {
    final db = await isar;
    
    await db.writeTxn(() async {
      await db.readingHistorys.delete(id);
    });
  }

  Future<void> clearAllHistory() async {
    final db = await isar;
    
    await db.writeTxn(() async {
      await db.readingHistorys.clear();
    });
  }

  // User Settings Methods
  Future<void> saveSetting(String key, String value) async {
    final db = await isar;
    
    await db.writeTxn(() async {
      final existingSetting = await db.userSettings
          .filter()
          .keyEqualTo(key)
          .findFirst();

      if (existingSetting != null) {
        existingSetting.value = value;
        await db.userSettings.put(existingSetting);
      } else {
        final newSetting = UserSettings.create(key: key, value: value);
        await db.userSettings.put(newSetting);
      }
    });
  }

  Future<String?> getSetting(String key) async {
    final db = await isar;
    
    final setting = await db.userSettings
        .filter()
        .keyEqualTo(key)
        .findFirst();
    
    return setting?.value;
  }

  Future<void> deleteSetting(String key) async {
    final db = await isar;
    
    await db.writeTxn(() async {
      await db.userSettings
          .filter()
          .keyEqualTo(key)
          .deleteFirst();
    });
  }

  Future<Map<String, String>> getAllSettings() async {
    final db = await isar;
    
    final settings = await db.userSettings.where().findAll();
    
    return Map.fromEntries(
      settings.map((setting) => MapEntry(setting.key, setting.value)),
    );
  }

  // Utility methods
  Future<void> closeDatabase() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
    }
  }
}

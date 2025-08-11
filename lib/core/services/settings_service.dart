import '../database/isar_service.dart';
import '../database/models/user_settings.dart';

class SettingsService {
  // Source selection persistence
  static Future<void> saveSelectedSource(String sourceId) async {
    await IsarService.instance.saveSetting(
      UserSettings.selectedSourceKey, 
      sourceId
    );
  }

  static Future<String?> getSelectedSource() async {
    return await IsarService.instance.getSetting(UserSettings.selectedSourceKey);
  }

  // Reading progress persistence
  static Future<void> saveLastReadManga(String mangaId) async {
    await IsarService.instance.saveSetting(
      'last_read_manga_id', 
      mangaId
    );
  }

  static Future<String?> getLastReadManga() async {
    return await IsarService.instance.getSetting('last_read_manga_id');
  }

  static Future<void> saveLastReadChapter(String chapterId) async {
    await IsarService.instance.saveSetting(
      'last_read_chapter_id', 
      chapterId
    );
  }

  static Future<String?> getLastReadChapter() async {
    return await IsarService.instance.getSetting('last_read_chapter_id');
  }

  // Reader settings
  static Future<void> saveReaderSettings(Map<String, dynamic> settings) async {
    // Convert settings to strings for storage
    for (final entry in settings.entries) {
      await IsarService.instance.saveSetting(
        'reader_settings_${entry.key}', 
        entry.value.toString()
      );
    }
  }

  static Future<Map<String, String>> getReaderSettings() async {
    final allSettings = await IsarService.instance.getAllSettings();
    
    // Filter only reader settings
    final readerSettings = <String, String>{};
    for (final entry in allSettings.entries) {
      if (entry.key.startsWith('reader_settings_')) {
        final settingKey = entry.key.replaceFirst('reader_settings_', '');
        readerSettings[settingKey] = entry.value;
      }
    }
    
    return readerSettings;
  }

  // Clear all settings
  static Future<void> clearAll() async {
    final allSettings = await IsarService.instance.getAllSettings();
    for (final key in allSettings.keys) {
      await IsarService.instance.deleteSetting(key);
    }
  }

  // Check if app is first launch
  static Future<bool> isFirstLaunch() async {
    final firstLaunch = await IsarService.instance.getSetting('first_launch');
    if (firstLaunch == null) {
      await IsarService.instance.saveSetting('first_launch', 'false');
      return true;
    }
    return false;
  }
}

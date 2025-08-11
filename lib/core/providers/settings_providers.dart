import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/settings_service.dart';

part 'settings_providers.g.dart';

// Settings service provider
@Riverpod(keepAlive: true)
SettingsService settingsService(SettingsServiceRef ref) {
  return SettingsService();
}

// Selected source persistence provider
@Riverpod(keepAlive: true)
class PersistedSelectedSource extends _$PersistedSelectedSource {
  @override
  Future<String?> build() async {
    return await SettingsService.getSelectedSource();
  }

  Future<void> saveSelectedSource(String sourceId) async {
    await SettingsService.saveSelectedSource(sourceId);
    state = AsyncValue.data(sourceId);
  }
}

// Last read manga persistence provider
@Riverpod(keepAlive: true)
class LastReadManga extends _$LastReadManga {
  @override
  Future<String?> build() async {
    return await SettingsService.getLastReadManga();
  }

  Future<void> saveLastReadManga(String mangaId) async {
    await SettingsService.saveLastReadManga(mangaId);
    state = AsyncValue.data(mangaId);
  }
}

// Last read chapter persistence provider
@Riverpod(keepAlive: true)
class LastReadChapter extends _$LastReadChapter {
  @override
  Future<String?> build() async {
    return await SettingsService.getLastReadChapter();
  }

  Future<void> saveLastReadChapter(String chapterId) async {
    await SettingsService.saveLastReadChapter(chapterId);
    state = AsyncValue.data(chapterId);
  }
}

// Reader settings persistence provider
@Riverpod(keepAlive: true)
class ReaderSettings extends _$ReaderSettings {
  @override
  Future<Map<String, String>> build() async {
    return await SettingsService.getReaderSettings();
  }

  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await SettingsService.saveReaderSettings(settings);
    state = AsyncValue.data(settings.map((k, v) => MapEntry(k, v.toString())));
  }
}

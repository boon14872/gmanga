// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsServiceHash() => r'acf8adce46f4f678aa987266d9a5a564e1692f9a';

/// See also [settingsService].
@ProviderFor(settingsService)
final settingsServiceProvider = Provider<SettingsService>.internal(
  settingsService,
  name: r'settingsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SettingsServiceRef = ProviderRef<SettingsService>;
String _$persistedSelectedSourceHash() =>
    r'adae618b92dea0192f5ad1583e6b78bba85c3b4a';

/// See also [PersistedSelectedSource].
@ProviderFor(PersistedSelectedSource)
final persistedSelectedSourceProvider =
    AsyncNotifierProvider<PersistedSelectedSource, String?>.internal(
  PersistedSelectedSource.new,
  name: r'persistedSelectedSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$persistedSelectedSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PersistedSelectedSource = AsyncNotifier<String?>;
String _$lastReadMangaHash() => r'fed11f9ad57077197b9f12e4cb989717d7c59b07';

/// See also [LastReadManga].
@ProviderFor(LastReadManga)
final lastReadMangaProvider =
    AsyncNotifierProvider<LastReadManga, String?>.internal(
  LastReadManga.new,
  name: r'lastReadMangaProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastReadMangaHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LastReadManga = AsyncNotifier<String?>;
String _$lastReadChapterHash() => r'7f1134fb1496fd4e57f185348569141183ff0447';

/// See also [LastReadChapter].
@ProviderFor(LastReadChapter)
final lastReadChapterProvider =
    AsyncNotifierProvider<LastReadChapter, String?>.internal(
  LastReadChapter.new,
  name: r'lastReadChapterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastReadChapterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LastReadChapter = AsyncNotifier<String?>;
String _$readerSettingsHash() => r'23a688e474072197cde961ea6d142b762e678b58';

/// See also [ReaderSettings].
@ProviderFor(ReaderSettings)
final readerSettingsProvider =
    AsyncNotifierProvider<ReaderSettings, Map<String, String>>.internal(
  ReaderSettings.new,
  name: r'readerSettingsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$readerSettingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReaderSettings = AsyncNotifier<Map<String, String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

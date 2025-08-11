import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:gmanga/features/browse/domain/manga_source.dart';
import 'package:gmanga/features/extensions/presentation/providers/extension_providers.dart';
import 'package:gmanga/core/providers/settings_providers.dart';

part 'source_providers.g.dart';

// Helper function to map extension IDs to asset paths
String _getAssetPathForExtension(String extensionId) {
  switch (extensionId) {
    case 'test':
      return 'assets/extensions/test_source.js';
    case 'nekopost':
      return 'assets/extensions/nekopost_source.js';
    case 'mangadx':
      return 'assets/extensions/mangadx_source.js';
    case 'comick':
      return 'assets/extensions/comick_source.js';
    case 'mikudoujin':
      return 'assets/extensions/mikudoujin_source.js';
    case 'niceoppai':
      return 'assets/extensions/niceoppai_source.js';
    default:
      return 'assets/extensions/${extensionId}_source.js';
  }
}

// Available manga sources - now dynamically loaded from extensions
@Riverpod(keepAlive: true)
List<MangaSource> availableSources(Ref ref) {
  final extensionsAsync = ref.watch(extensionListProvider);
  
  return extensionsAsync.when(
    data: (extensions) {
      // Convert enabled extensions to manga sources
      final enabledSources = extensions
          .where((ext) => ext.isEnabled)
          .map((ext) => MangaSource(
                id: ext.id,
                name: ext.name,
                assetPath: _getAssetPathForExtension(ext.id),
                isEnabled: ext.isEnabled,
              ))
          .toList();
      
      // If no extensions are enabled, return default sources to prevent empty state
      if (enabledSources.isEmpty) {
        return const [
          MangaSource(
            id: 'nekopost',
            name: 'NekoPost',
            assetPath: 'assets/extensions/nekopost_source.js',
          ),
        ];
      }
      
      return enabledSources;
    },
    loading: () => const [
      MangaSource(
        id: 'nekopost',
        name: 'NekoPost',
        assetPath: 'assets/extensions/nekopost_source.js',
      ),
    ],
    error: (_, __) => const [
      MangaSource(
        id: 'nekopost',
        name: 'NekoPost',
        assetPath: 'assets/extensions/nekopost_source.js',
      ),
    ],
  );
}

// Currently selected source with persistence
@riverpod
class SelectedSource extends _$SelectedSource {
  @override
  MangaSource build() {
    final sources = ref.watch(availableSourcesProvider);
    final persistedSourceAsync = ref.watch(persistedSelectedSourceProvider);
    
    // Use persisted source if available, otherwise default to first source
    return persistedSourceAsync.when(
      data: (persistedSourceId) {
        if (persistedSourceId != null) {
          final persistedSource = sources.firstWhere(
            (source) => source.id == persistedSourceId,
            orElse: () => sources.isNotEmpty ? sources.first : const MangaSource(
              id: 'nekopost',
              name: 'NekoPost',
              assetPath: 'assets/extensions/nekopost_source.js',
            ),
          );
          return persistedSource;
        }
        return sources.isNotEmpty ? sources.first : const MangaSource(
          id: 'nekopost',
          name: 'NekoPost',
          assetPath: 'assets/extensions/nekopost_source.js',
        );
      },
      loading: () => sources.isNotEmpty ? sources.first : const MangaSource(
        id: 'nekopost',
        name: 'NekoPost',
        assetPath: 'assets/extensions/nekopost_source.js',
      ),
      error: (_, __) => sources.isNotEmpty ? sources.first : const MangaSource(
        id: 'nekopost',
        name: 'NekoPost',
        assetPath: 'assets/extensions/nekopost_source.js',
      ),
    );
  }

  void selectSource(MangaSource source) {
    state = source;
    // Persist the selection
    ref.read(persistedSelectedSourceProvider.notifier).saveSelectedSource(source.id);
  }
}

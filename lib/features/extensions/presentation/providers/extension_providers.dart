import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gmanga/features/extensions/domain/extension_source.dart';

part 'extension_providers.g.dart';

// Simple in-memory extension provider
@riverpod
class ExtensionList extends _$ExtensionList {
  @override
  Future<List<ExtensionSource>> build() async {
    // Return a list of available extensions
    return [
      ExtensionSource(
        id: 'test',
        name: 'Test Source (JSONPlaceholder)',
        version: '1.0.0',
        lang: 'en',
        isEnabled: true,
      ),
      ExtensionSource(
        id: 'nekopost',
        name: 'NekoPost',
        version: '1.0.0',
        lang: 'th',
        isEnabled: true,
      ),
      ExtensionSource(
        id: 'mangadx',
        name: 'MangaDx',
        version: '1.0.0',
        lang: 'en',
        isEnabled: false,
      ),
      ExtensionSource(
        id: 'comick',
        name: 'Comick',
        version: '1.0.0',
        lang: 'en',
        isEnabled: false,
      ),
    ];
  }

  Future<void> toggle(String extensionId) async {
    final current = await future;
    final updated = current.map((ext) {
      if (ext.id == extensionId) {
        return ExtensionSource(
          id: ext.id,
          name: ext.name,
          version: ext.version,
          lang: ext.lang,
          isEnabled: !ext.isEnabled,
        );
      }
      return ext;
    }).toList();
    
    // Update the state
    state = AsyncData(updated);
  }
  
  Future<void> importFromUrl(String url) async {
    // For now, just show a placeholder functionality
    // In a real implementation, this would fetch extension metadata from the URL
    print('Importing extension from URL: $url');
    // This is a stub implementation for now
  }
}
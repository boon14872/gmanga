import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gmanga/features/extensions/domain/extension_source.dart';
import 'package:file_picker/file_picker.dart';

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

  Future<ExtensionSource?> loadExtensionFromFile() async {
    try {
      // Use file picker to select a JavaScript file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['js'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final content = String.fromCharCodes(file.bytes!);
        
        // Parse extension metadata from JavaScript comments
        final metadata = _parseExtensionMetadata(content);
        if (metadata == null) {
          throw Exception('Invalid extension file: Missing metadata');
        }

        // Validate extension content
        if (!_validateExtensionContent(content)) {
          throw Exception('Invalid extension file: Missing required functions');
        }

        // Create ExtensionSource object
        final extension = ExtensionSource(
          id: metadata['id']!,
          name: metadata['name']!,
          version: metadata['version']!,
          lang: metadata['lang'] ?? 'en',
          isEnabled: true,
        );

        // Add to current list
        final current = await future;
        final updated = [...current, extension];
        state = AsyncData(updated);

        return extension;
      }
    } catch (e) {
      print('Error loading extension from file: $e');
    }
    return null;
  }

  /// Parse extension metadata from JavaScript comments
  Map<String, String>? _parseExtensionMetadata(String content) {
    final lines = content.split('\n');
    final metadata = <String, String>{};
    
    bool inMetadataBlock = false;
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      
      // Look for metadata block start
      if (trimmedLine.startsWith('/**') || trimmedLine.startsWith('/*')) {
        inMetadataBlock = true;
        continue;
      }
      
      // Look for metadata block end
      if (trimmedLine.endsWith('*/')) {
        inMetadataBlock = false;
        break;
      }
      
      // Parse metadata within block
      if (inMetadataBlock && trimmedLine.startsWith('*')) {
        final metadataLine = trimmedLine.substring(1).trim();
        
        // Parse @key value format
        if (metadataLine.startsWith('@')) {
          final parts = metadataLine.split(' ');
          if (parts.length >= 2) {
            final key = parts[0].substring(1); // Remove @
            final value = parts.sublist(1).join(' ');
            metadata[key] = value;
          }
        }
      }
    }

    // Validate required metadata
    if (!metadata.containsKey('id') || 
        !metadata.containsKey('name') || 
        !metadata.containsKey('version')) {
      return null;
    }

    return metadata;
  }

  /// Validate that extension contains required functions
  bool _validateExtensionContent(String content) {
    final requiredFunctions = [
      'getPopularUrl',
      'parsePopular',
    ];

    for (final func in requiredFunctions) {
      if (!content.contains(func)) {
        return false;
      }
    }

    return true;
  }
}
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gmanga/features/extensions/domain/extension_source.dart';
import 'package:gmanga/core/database/isar_service.dart';
import 'package:gmanga/features/extensions/data/isar_extension_source.dart';

class ExtensionService {
  static ExtensionService? _instance;
  static ExtensionService get instance => _instance ??= ExtensionService._();
  ExtensionService._();

  /// Load an extension from a file
  Future<ExtensionSource?> loadExtensionFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Extension file not found: $filePath');
      }

      // Check if it's a JavaScript file
      if (!filePath.toLowerCase().endsWith('.js')) {
        throw Exception('Extension must be a .js file');
      }

      final content = await file.readAsString();
      
      // Parse extension metadata from JavaScript comments
      final metadata = _parseExtensionMetadata(content);
      if (metadata == null) {
        throw Exception('Invalid extension file: Missing metadata');
      }

      // Validate extension content
      if (!_validateExtensionContent(content)) {
        throw Exception('Invalid extension file: Missing required functions');
      }

      // Copy extension to app directory
      final extensionPath = await _copyExtensionToAppDirectory(file, metadata['id']!);
      
      // Create ExtensionSource object
      final extension = ExtensionSource(
        id: metadata['id']!,
        name: metadata['name']!,
        version: metadata['version']!,
        lang: metadata['lang'] ?? 'en',
        isEnabled: true,
      );

      // Save to database
      await _saveExtensionToDatabase(extension, extensionPath);

      return extension;
    } catch (e) {
      print('Error loading extension from file: $e');
      return null;
    }
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

  /// Copy extension file to app's extensions directory
  Future<String> _copyExtensionToAppDirectory(File sourceFile, String extensionId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final extensionsDir = Directory('${appDir.path}/extensions');
    
    // Create extensions directory if it doesn't exist
    if (!await extensionsDir.exists()) {
      await extensionsDir.create(recursive: true);
    }

    // Copy file with standardized name
    final targetFile = File('${extensionsDir.path}/${extensionId}_source.js');
    await sourceFile.copy(targetFile.path);
    
    return targetFile.path;
  }

  /// Save extension metadata to database
  Future<void> _saveExtensionToDatabase(ExtensionSource extension, String filePath) async {
    final isarService = IsarService.instance;
    final db = await isarService.isar;
    
    final isarExtension = IsarExtensionSource()
      ..sourceId = extension.id
      ..name = extension.name
      ..version = extension.version
      ..lang = extension.lang
      ..isEnabled = extension.isEnabled;

    await db.writeTxn(() async {
      await db.isarExtensionSources.putBySourceId(isarExtension);
    });

    // Save file path in shared preferences or additional storage if needed
    print('Extension saved to database: ${extension.name} (${extension.id})');
  }

  /// Get installed extensions from database
  Future<List<ExtensionSource>> getInstalledExtensions() async {
    final isarService = IsarService.instance;
    final db = await isarService.isar;
    
    final isarExtensions = await db.isarExtensionSources.where().findAll();
    
    return isarExtensions.map((isarExt) => ExtensionSource(
      id: isarExt.sourceId,
      name: isarExt.name,
      version: isarExt.version,
      lang: isarExt.lang,
      isEnabled: isarExt.isEnabled,
    )).toList();
  }

  /// Toggle extension enabled state
  Future<void> toggleExtension(String extensionId) async {
    final isarService = IsarService.instance;
    final db = await isarService.isar;
    
    await db.writeTxn(() async {
      final extension = await db.isarExtensionSources.getBySourceId(extensionId);
      if (extension != null) {
        extension.isEnabled = !extension.isEnabled;
        await db.isarExtensionSources.putBySourceId(extension);
      }
    });
  }

  /// Remove extension
  Future<bool> removeExtension(String extensionId) async {
    try {
      final isarService = IsarService.instance;
      final db = await isarService.isar;
      
      // Remove from database
      await db.writeTxn(() async {
        await db.isarExtensionSources.deleteBySourceId(extensionId);
      });

      // Remove file from app directory
      final appDir = await getApplicationDocumentsDirectory();
      final extensionFile = File('${appDir.path}/extensions/${extensionId}_source.js');
      if (await extensionFile.exists()) {
        await extensionFile.delete();
      }

      return true;
    } catch (e) {
      print('Error removing extension: $e');
      return false;
    }
  }

  /// Get extension file path for JavaScript loading
  Future<String?> getExtensionFilePath(String extensionId) async {
    // First check if it's a built-in extension
    final builtInExtensions = [
      'test', 'nekopost', 'mangadx', 'comick', 'mikudoujin', 'niceoppai'
    ];
    
    if (builtInExtensions.contains(extensionId)) {
      return 'assets/extensions/${extensionId}_source.js';
    }

    // Check for user-installed extension
    final appDir = await getApplicationDocumentsDirectory();
    final extensionFile = File('${appDir.path}/extensions/${extensionId}_source.js');
    
    if (await extensionFile.exists()) {
      return extensionFile.path;
    }

    return null;
  }

  /// Install extension from URL (future feature)
  Future<ExtensionSource?> installExtensionFromUrl(String url) async {
    // TODO: Implement URL-based extension installation
    // This would download the JS file from the URL and install it
    print('URL-based installation not yet implemented: $url');
    return null;
  }
}

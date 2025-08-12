import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:gmanga/features/extensions/domain/extension_source.dart';
import 'package:gmanga/features/extensions/domain/extension_repository.dart';
import 'package:gmanga/features/extensions/data/isar_extension_repository.dart';
import 'package:gmanga/core/database/isar_service.dart';

// Extension repository provider
final extensionRepositoryProvider = FutureProvider<ExtensionRepository>((ref) async {
  final isar = await IsarService.instance.isar;
  return IsarExtensionRepository(isar);
});

// Simple extension list provider
final extensionListProvider = StateNotifierProvider<ExtensionListNotifier, AsyncValue<List<ExtensionSource>>>((ref) {
  return ExtensionListNotifier(ref);
});

class ExtensionListNotifier extends StateNotifier<AsyncValue<List<ExtensionSource>>> {
  final Ref _ref;
  
  ExtensionListNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadExtensions();
  }
  
  Future<void> _loadExtensions() async {
    state = const AsyncValue.loading();
    try {
      final repositoryAsync = await _ref.read(extensionRepositoryProvider.future);
      final extensions = await repositoryAsync.getInstalledExtensions();
      state = AsyncValue.data(extensions);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<void> toggle(String extensionId) async {
    try {
      final repository = await _ref.read(extensionRepositoryProvider.future);
      await repository.toggleExtension(extensionId);
      _loadExtensions(); // Reload to reflect changes
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
  
  Future<ExtensionSource?> loadExtensionFromFile() async {
    try {
      // Use file picker to select a JavaScript file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['js'],
        allowMultiple: false,
        withData: true,
      );
      
      if (result != null && result.files.single.bytes != null) {
        final fileBytes = result.files.single.bytes!;
        final fileName = result.files.single.name;
        final fileContent = String.fromCharCodes(fileBytes);
        
        // Parse the JavaScript extension file to extract metadata
        final extensionSource = _parseExtensionFromScript(fileContent, fileName);
        
        if (extensionSource != null) {
          // Save the extension using the repository
          final repository = await _ref.read(extensionRepositoryProvider.future);
          
          // Create a temporary file path for the extension
          final extensionId = extensionSource.id;
          final extensionPath = 'extensions/$extensionId.js';
          
          // Save the extension content (this would typically save to assets or app directory)
          await _saveExtensionFile(extensionPath, fileContent);
          
          // Add to repository
          await repository.importFromUrl(extensionPath);
          
          // Reload extensions list
          _loadExtensions();
          
          return extensionSource;
        }
      }
      
      return null;
    } catch (error) {
      print('Error loading extension from file: $error');
      return null;
    }
  }
  
  // Helper method to parse extension metadata from JavaScript content
  ExtensionSource? _parseExtensionFromScript(String content, String fileName) {
    try {
      // Look for extension metadata in comments or specific patterns
      // This is a simplified parser - in a real app you'd use a proper JS parser
      
      final idMatch = RegExp(r'id:\s*["\x27]([^"\x27]+)["\x27]').firstMatch(content);
      final nameMatch = RegExp(r'name:\s*["\x27]([^"\x27]+)["\x27]').firstMatch(content);
      final versionMatch = RegExp(r'version:\s*["\x27]([^"\x27]+)["\x27]').firstMatch(content);
      final langMatch = RegExp(r'lang:\s*["\x27]([^"\x27]+)["\x27]').firstMatch(content);
      
      final id = idMatch?.group(1) ?? fileName.replaceAll('.js', '');
      final name = nameMatch?.group(1) ?? fileName.replaceAll('.js', '');
      final version = versionMatch?.group(1) ?? '1.0.0';
      final lang = langMatch?.group(1) ?? 'en';
      
      return ExtensionSource(
        id: id,
        name: name,
        version: version,
        lang: lang,
        isEnabled: false,
      );
    } catch (e) {
      print('Error parsing extension script: $e');
      return null;
    }
  }
  
  // Helper method to save extension file
  Future<void> _saveExtensionFile(String path, String content) async {
    try {
      // In a real implementation, you'd save to the app's documents directory
      // or assets folder. For now, we'll just print the action.
      print('Saving extension to path: $path');
      print('Content length: ${content.length} characters');
      
      // TODO: Implement actual file saving to app directory
      // final directory = await getApplicationDocumentsDirectory();
      // final file = File('${directory.path}/$path');
      // await file.create(recursive: true);
      // await file.writeAsString(content);
    } catch (e) {
      print('Error saving extension file: $e');
      rethrow;
    }
  }
  
  Future<void> importFromUrl(String url) async {
    try {
      final repository = await _ref.read(extensionRepositoryProvider.future);
      await repository.importFromUrl(url);
      _loadExtensions(); // Reload to reflect changes
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

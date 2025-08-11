import 'package:gmanga/features/extensions/domain/extension_source.dart';

abstract class ExtensionRepository {
  Future<List<ExtensionSource>> getInstalledExtensions();
  Future<void> toggleExtension(String extensionId);
  Future<void> importFromUrl(String url);
}
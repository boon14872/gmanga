import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:gmanga/features/extensions/data/isar_extension_source.dart';
import 'package:gmanga/features/extensions/domain/extension_source.dart';
import 'package:gmanga/features/extensions/domain/extension_repository.dart';

class IsarExtensionRepository implements ExtensionRepository {
  final Isar _isar;
  final Dio _dio = Dio();

  IsarExtensionRepository(this._isar) {
    // Pre-seed the database with an initial extension if it's empty
    _seedInitialData();
  }
  
  Future<void> _seedInitialData() async {
    // Always re-seed to include new extensions - you can change this logic later
    final existingCount = await _isar.isarExtensionSources.count();
    if (existingCount < 6) { // Force reseed if we don't have all 6 extensions
      print("Database has $existingCount extensions. Re-seeding to include all extensions...");
      
      // Clear existing data first
      await _isar.writeTxn(() async {
        await _isar.isarExtensionSources.clear();
      });
      
      final initialExtensions = [
        IsarExtensionSource()
          ..sourceId = 'test'
          ..name = 'Test API'
          ..version = '1.0.0'
          ..lang = 'EN'
          ..isEnabled = true,
        IsarExtensionSource()
          ..sourceId = 'nekopost'
          ..name = 'NekoPost'
          ..version = '1.0.0'
          ..lang = 'TH'
          ..isEnabled = true,
        IsarExtensionSource()
          ..sourceId = 'mangadex'
          ..name = 'MangaDex'
          ..version = '1.0.0'
          ..lang = 'EN'
          ..isEnabled = true,
        IsarExtensionSource()
          ..sourceId = 'comick'
          ..name = 'Comick'
          ..version = '1.2.5'
          ..lang = 'EN'
          ..isEnabled = true,
        IsarExtensionSource()
          ..sourceId = 'mikudoujin'
          ..name = 'MikuDoujin'
          ..version = '1.0.0'
          ..lang = 'TH'
          ..isEnabled = true,
        IsarExtensionSource()
          ..sourceId = 'niceoppai'
          ..name = 'NiceOppai'
          ..version = '1.0.0'
          ..lang = 'TH'
          ..isEnabled = true,
      ];
      
      // Perform a write transaction to add the data
      await _isar.writeTxn(() async {
        await _isar.isarExtensionSources.putAll(initialExtensions);
      });
      print("Seeding complete with ${initialExtensions.length} extensions.");
    } else {
      print("Database already has ${existingCount} extensions.");
    }
  }

  @override
  Future<List<ExtensionSource>> getInstalledExtensions() async {
    // Fetch all records from the Isar collection
    final records = await _isar.isarExtensionSources.where().findAll();
    
    // Map the database objects to our domain models
    return records.map((e) => ExtensionSource(
      id: e.sourceId,
      name: e.name,
      version: e.version,
      lang: e.lang,
      isEnabled: e.isEnabled,
    )).toList();
  }

  @override
  Future<void> toggleExtension(String extensionId) async {
    // Start a write transaction
    await _isar.writeTxn(() async {
      // Find the specific extension by its unique sourceId
      final record = await _isar.isarExtensionSources.filter().sourceIdEqualTo(extensionId).findFirst();
      if (record != null) {
        // Modify the record and save it back to the database
        record.isEnabled = !record.isEnabled;
        await _isar.isarExtensionSources.put(record);
      }
    });
  }

  @override
  Future<void> importFromUrl(String url) async {
    try {
      // In a real app, this would be a URL to a repo.json file
      // For this example, we simulate a successful download.
      print("Fetching extensions from $url");
      // final response = await _dio.get(url);
      // final List<dynamic> extensionList = response.data;
      await Future.delayed(const Duration(seconds: 2));
      final List<dynamic> extensionList = [
        { "id": "new_source_1", "name": "New Source from URL", "version": "1.0.0", "lang": "EN", "isEnabled": true },
        { "id": "new_source_2", "name": "Another Source", "version": "3.1.0", "lang": "JP", "isEnabled": false }
      ];

      final newRecords = extensionList.map((ext) => IsarExtensionSource()
        ..sourceId = ext['id']
        ..name = ext['name']
        ..version = ext['version']
        ..lang = ext['lang']
        ..isEnabled = ext['isEnabled']
      ).toList();

      // Save all new records to the database in a single transaction
      await _isar.writeTxn(() async {
        await _isar.isarExtensionSources.putAll(newRecords);
      });
      print("Successfully imported ${newRecords.length} extensions.");
    } catch (e) {
      print("Failed to import extensions: $e");
      // Optionally re-throw the error to be handled by the UI
      rethrow;
    }
  }
}
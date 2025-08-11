import 'package:isar/isar.dart';

part 'user_settings.g.dart';

@collection
class UserSettings {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String key;

  late String value;

  // Constructor
  UserSettings();

  // Named constructor for creating settings
  UserSettings.create({
    required this.key,
    required this.value,
  });

  // Common setting keys
  static const String selectedSourceKey = 'selected_source';
  static const String readingModeKey = 'reading_mode';
  static const String brightnessKey = 'brightness';
  static const String autoSaveProgressKey = 'auto_save_progress';
}

class ExtensionSource {
  final String id;
  final String name;
  final String version;
  final String lang;
  final bool isEnabled;

  ExtensionSource({
    required this.id,
    required this.name,
    required this.version,
    required this.lang,
    required this.isEnabled,
  });

  // Helper method to create a copy with modified values
  ExtensionSource copyWith({bool? isEnabled}) {
    return ExtensionSource(
      id: id,
      name: name,
      version: version,
      lang: lang,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
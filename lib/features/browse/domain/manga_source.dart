class MangaSource {
  final String id;
  final String name;
  final String assetPath;
  final bool isEnabled;

  const MangaSource({
    required this.id,
    required this.name,
    required this.assetPath,
    this.isEnabled = true,
  });

  MangaSource copyWith({
    String? id,
    String? name,
    String? assetPath,
    bool? isEnabled,
  }) {
    return MangaSource(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MangaSource && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

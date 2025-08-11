class LibraryManga {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String? author;
  final String? status;
  final DateTime addedDate;
  final int? lastReadChapter;
  final bool isFavorite;

  LibraryManga({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    this.author,
    this.status,
    required this.addedDate,
    this.lastReadChapter,
    this.isFavorite = false,
  });

  LibraryManga copyWith({
    String? id,
    String? title,
    String? thumbnailUrl,
    String? author,
    String? status,
    DateTime? addedDate,
    int? lastReadChapter,
    bool? isFavorite,
  }) {
    return LibraryManga(
      id: id ?? this.id,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      author: author ?? this.author,
      status: status ?? this.status,
      addedDate: addedDate ?? this.addedDate,
      lastReadChapter: lastReadChapter ?? this.lastReadChapter,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

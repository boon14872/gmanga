class MangaDetail {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String? author;
  final String? artist;
  final String description;
  final List<String> genres;
  final String status;
  final DateTime? lastUpdated;

  MangaDetail({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    this.author,
    this.artist,
    required this.description,
    required this.genres,
    required this.status,
    this.lastUpdated,
  });

  factory MangaDetail.fromJson(Map<String, dynamic> json) {
    return MangaDetail(
      id: json['id'] as String,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      author: json['author'] as String?,
      artist: json['artist'] as String?,
      description: json['description'] as String? ?? '',
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      status: json['status'] as String? ?? 'Unknown',
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.tryParse(json['lastUpdated'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'author': author,
      'artist': artist,
      'description': description,
      'genres': genres,
      'status': status,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
}

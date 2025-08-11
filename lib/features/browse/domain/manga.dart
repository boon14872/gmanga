// POCOs (Plain Old C# Objects)
class Manga {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String? author;
  final String? artist;
  final String? description;
  final List<String>? genres;
  final String? status;

  Manga({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    this.author,
    this.artist,
    this.description,
    this.genres,
    this.status,
  });
}

class Chapter {
  final String id;
  final String name;
  final DateTime uploadDate;

  Chapter({required this.id, required this.name, required this.uploadDate});
}
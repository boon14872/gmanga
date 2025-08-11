import 'package:isar/isar.dart';

part 'reading_history.g.dart';

@collection
class ReadingHistory {
  Id id = Isar.autoIncrement;

  @Index()
  late String mangaId;

  late String mangaTitle;

  @Index()
  late String chapterId;

  late String chapterTitle;

  late int currentPage;

  late int totalPages;

  @Index()
  late DateTime lastReadAt;

  // Constructor
  ReadingHistory();

  // Named constructor for creating from JSON-like data
  ReadingHistory.fromJson(Map<String, dynamic> json) {
    mangaId = json['mangaId'] ?? '';
    mangaTitle = json['mangaTitle'] ?? '';
    chapterId = json['chapterId'] ?? '';
    chapterTitle = json['chapterTitle'] ?? '';
    currentPage = json['currentPage'] ?? 0;
    totalPages = json['totalPages'] ?? 0;
    lastReadAt = json['lastReadAt'] != null 
        ? DateTime.parse(json['lastReadAt']) 
        : DateTime.now();
  }

  // Convert to JSON-like data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mangaId': mangaId,
      'mangaTitle': mangaTitle,
      'chapterId': chapterId,
      'chapterTitle': chapterTitle,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'lastReadAt': lastReadAt.toIso8601String(),
    };
  }

  // Calculate reading progress percentage
  double get progressPercentage {
    if (totalPages <= 0) return 0.0;
    return (currentPage + 1) / totalPages;
  }

  // Check if chapter is completed
  bool get isCompleted => currentPage >= totalPages - 1;
}

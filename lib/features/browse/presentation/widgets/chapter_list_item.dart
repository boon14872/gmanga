import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gmanga/features/browse/domain/manga.dart';

class ChapterListItem extends StatelessWidget {
  final Chapter chapter;
  const ChapterListItem({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chapter.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(DateFormat.yMMMd().format(chapter.uploadDate)),
      onTap: () {
        // TODO: Navigate to Reader Screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on ${chapter.name}')),
        );
      },
    );
  }
}
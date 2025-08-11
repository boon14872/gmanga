import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/library_providers.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryManga = ref.watch(libraryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Add filter options: All, Favorites, Reading, etc.
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All')),
              const PopupMenuItem(value: 'favorites', child: Text('Favorites')),
              const PopupMenuItem(value: 'reading', child: Text('Reading')),
            ],
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: libraryManga.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your library is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add manga from Browse to get started',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: libraryManga.length,
              itemBuilder: (context, index) {
                final manga = libraryManga[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/manga',
                        arguments: {
                          'id': manga.id,
                          'title': manga.title,
                          'thumbnailUrl': manga.thumbnailUrl,
                          'author': manga.author,
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(manga.thumbnailUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (manga.isFavorite)
                                const Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              if (manga.lastReadChapter != null)
                                Positioned(
                                  bottom: 4,
                                  left: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Ch. ${manga.lastReadChapter}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                manga.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              if (manga.author != null)
                                Text(
                                  manga.author!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

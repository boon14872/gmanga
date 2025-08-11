import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gmanga/features/browse/domain/manga.dart';

class MangaDetailsHeader extends StatelessWidget {
  final Manga manga;
  const MangaDetailsHeader({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 56, vertical: 16),
        centerTitle: false,
        title: Text(
          manga.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(shadows: [Shadow(blurRadius: 4, color: Colors.black87)]),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: manga.thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[900]),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, 0.7),
                  end: Alignment.center,
                  colors: <Color>[Color(0x60000000), Color(0x00000000)],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: Container(
           padding: const EdgeInsets.all(16.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                Text("By ${manga.author ?? 'Unknown'}", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (manga.genres != null && manga.genres!.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: manga.genres!.take(4).map((genre) => Chip(label: Text(genre))).toList(),
                  ),
                const SizedBox(height: 8),
                Text(
                  manga.description ?? 'No description available.',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
             ],
           ),
        ),
      ),
    );
  }
}
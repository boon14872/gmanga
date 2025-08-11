import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gmanga/features/browse/domain/manga.dart';

class MangaGridItem extends StatelessWidget {
  final Manga manga;
  final VoidCallback onTap;

  const MangaGridItem({super.key, required this.manga, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: manga.thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[900]),
              errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.transparent],
                  ),
                ),
                child: Text(
                  manga.title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, shadows: [
                    const Shadow(blurRadius: 2, color: Colors.black)
                  ]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
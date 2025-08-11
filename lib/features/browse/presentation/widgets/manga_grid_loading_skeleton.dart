import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MangaGridLoadingSkeleton extends StatelessWidget {
  const MangaGridLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[850]!,
      highlightColor: Colors.grey[800]!,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Container(color: Colors.black),
          );
        },
      ),
    );
  }
}
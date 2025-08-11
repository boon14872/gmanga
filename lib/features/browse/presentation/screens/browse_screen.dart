import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmanga/features/browse/presentation/providers/manga_providers.dart';
import 'package:gmanga/features/browse/presentation/providers/source_providers.dart';
import 'package:gmanga/features/browse/presentation/widgets/manga_grid_item.dart';
import 'package:gmanga/features/browse/presentation/widgets/manga_grid_loading_skeleton.dart';
import 'package:gmanga/features/library/presentation/providers/library_providers.dart';
import 'package:gmanga/shared/widgets/error_display.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Load more manga when near bottom
      ref.read(browseSourceProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final browseState = ref.watch(browseSourceProvider);
    final availableSources = ref.watch(availableSourcesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Manga'),
        centerTitle: false,
        actions: [
          // Source dropdown in a more compact form
          PopupMenuButton(
            icon: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Source', style: TextStyle(fontSize: 14)),
                Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
            itemBuilder: (context) => availableSources.map((source) {
              return PopupMenuItem(
                value: source,
                child: Text(source.name),
              );
            }).toList(),
            onSelected: (newSource) {
              ref.read(selectedSourceProvider.notifier).selectSource(newSource);
            },
          ),
          IconButton(
            icon: const Icon(Icons.extension_outlined),
            tooltip: 'Extensions',
            onPressed: () => Navigator.pushNamed(context, '/extensions'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(browseSourceProvider.future),
        child: browseState.when(
          loading: () => const MangaGridLoadingSkeleton(),
          error: (error, stackTrace) => ErrorDisplay(
            error: error.toString(),
            onRetry: () => ref.invalidate(browseSourceProvider),
          ),
          data: (mangaList) {
            final isLoadingMore = ref.watch(loadingMoreProvider);
            return Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: mangaList.length,
                    itemBuilder: (context, index) {
                      final manga = mangaList[index];
                      return MangaGridItem(
                        manga: manga,
                        onTap: () {
                          // Navigate to manga details
                          Navigator.pushNamed(
                            context, 
                            '/manga',
                            arguments: {
                              'id': manga.id,
                              'title': manga.title,
                              'thumbnailUrl': manga.thumbnailUrl,
                              'author': manga.author,
                              'description': manga.description,
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                // Loading indicator for pagination
                if (isLoadingMore)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 12),
                        Text('Loading more...'),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

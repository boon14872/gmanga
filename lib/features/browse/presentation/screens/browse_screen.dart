import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmanga/core/services/cache_service.dart';
import 'package:gmanga/features/browse/presentation/providers/manga_providers.dart';
import 'package:gmanga/features/browse/presentation/providers/source_providers.dart';
import 'package:gmanga/features/browse/presentation/widgets/manga_grid_item.dart';
import 'package:gmanga/features/browse/presentation/widgets/manga_grid_loading_skeleton.dart';
import 'package:gmanga/shared/widgets/error_display.dart';
import 'package:go_router/go_router.dart';

class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    _autoLoadExtensions();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _autoLoadExtensions() {
    // Auto-refresh sources on startup to load any new extensions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(availableSourcesProvider);
      // Clear expired cache on startup
      CacheService.instance.clearExpiredCache();
    });
  }

  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      // For now, just print the search - we can implement full search later
      print('🔍 Searching for: $query');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Search feature coming soon! Query: "$query"'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search manga...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _performSearch(),
              )
            : const Text('Popular Manga'),
        centerTitle: false,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                    _searchController.clear();
                  });
                },
              )
            : null,
        actions: [
          if (!_isSearching) ...[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
            // Latest Updates button
            IconButton(
              icon: const Icon(Icons.update),
              tooltip: 'Show Latest Updates',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Latest updates feature coming soon!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
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
              return PopupMenuItem(value: source, child: Text(source.name));
            }).toList(),
            onSelected: (newSource) {
              ref.read(selectedSourceProvider.notifier).selectSource(newSource);
            },
          ),
          IconButton(
            icon: const Icon(Icons.extension_outlined),
            tooltip: 'Extensions',
            onPressed: () {
              context.go('/extensions');
            },
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          // Navigate to manga details using GoRouter
                          context.go('/manga/${manga.id}');
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

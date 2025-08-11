import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/manga_page.dart';
import '../../../browse/presentation/providers/manga_providers.dart';
import '../../../browse/presentation/providers/source_providers.dart';

// Reader state management
final readerProvider = StateNotifierProvider.family<ReaderNotifier, ReaderState, String>((ref, chapterId) {
  final repository = ref.read(mangaRepositoryProvider);
  final selectedSource = ref.read(selectedSourceProvider);
  return ReaderNotifier(chapterId, repository, selectedSource);
});

final currentPageProvider = StateProvider<int>((ref) => 0);

final isFullscreenProvider = StateProvider<bool>((ref) => false);

class ReaderState {
  final List<MangaPage> pages;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final Set<String> preloadedImages;
  final String? nextChapterId;
  final bool isLoadingNextChapter;

  ReaderState({
    this.pages = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.preloadedImages = const {},
    this.nextChapterId,
    this.isLoadingNextChapter = false,
  });

  ReaderState copyWith({
    List<MangaPage>? pages,
    bool? isLoading,
    bool? hasMore,
    String? error,
    Set<String>? preloadedImages,
    String? nextChapterId,
    bool? isLoadingNextChapter,
  }) {
    return ReaderState(
      pages: pages ?? this.pages,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
      preloadedImages: preloadedImages ?? this.preloadedImages,
      nextChapterId: nextChapterId ?? this.nextChapterId,
      isLoadingNextChapter: isLoadingNextChapter ?? this.isLoadingNextChapter,
    );
  }
}

class ReaderNotifier extends StateNotifier<ReaderState> {
  final String chapterId;
  final repository;
  final selectedSource;
  List<MangaPage> _allPages = [];
  bool _pagesLoaded = false;
  String? mangaId;
  List<String> _allChapterIds = [];
  int _currentChapterIndex = -1;

  ReaderNotifier(this.chapterId, this.repository, this.selectedSource) : super(ReaderState()) {
    loadPages();
  }

  void setMangaContext(String? mangaIdParam, List<String> chapterIds) {
    mangaId = mangaIdParam;
    _allChapterIds = chapterIds;
    _currentChapterIndex = chapterIds.indexOf(chapterId);
    
    // Set next chapter if available
    if (_currentChapterIndex >= 0 && _currentChapterIndex < chapterIds.length - 1) {
      state = state.copyWith(nextChapterId: chapterIds[_currentChapterIndex + 1]);
    }
  }

  Future<void> loadPages() async {
    if (_pagesLoaded) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      print('Loading pages for chapter: $chapterId');
      final pages = await repository.getPages(chapterId, source: selectedSource);
      
      print('Successfully loaded ${pages.length} pages from extension');
      
      if (pages.isEmpty) {
        print('No pages returned from extension - this means API failed or no data available');
        state = state.copyWith(
          isLoading: false,
          error: 'No pages available for this chapter. The manga source may not have this chapter or there might be an API issue.',
        );
        return;
      }
      
      _allPages = pages;
      _pagesLoaded = true;
      
      // Load first batch
      final initialBatch = _allPages.take(5).toList();
      state = state.copyWith(
        pages: initialBatch,
        isLoading: false,
        hasMore: _allPages.length > 5,
      );
      
      // Start preloading images
      _preloadImages(initialBatch);
      
    } catch (e) {
      print('Error loading pages: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load pages: $e',
      );
    }
  }

  Future<void> _preloadImages(List<MangaPage> pages) async {
    final preloadedImages = Set<String>.from(state.preloadedImages);
    
    for (final page in pages) {
      if (!preloadedImages.contains(page.imageUrl)) {
        try {
          // Use a basic HTTP request to preload the image
          print('Preloading image: ${page.imageUrl}');
          preloadedImages.add(page.imageUrl);
        } catch (e) {
          print('Failed to preload image: ${page.imageUrl}, error: $e');
        }
      }
    }
    
    state = state.copyWith(preloadedImages: preloadedImages);
  }

  Future<void> loadMorePages() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    
    try {
      final currentLength = state.pages.length;
      final nextBatch = _allPages.skip(currentLength).take(5).toList();
      
      final updatedPages = [...state.pages, ...nextBatch];
      final hasMore = updatedPages.length < _allPages.length;
      
      state = state.copyWith(
        pages: updatedPages,
        isLoading: false,
        hasMore: hasMore,
      );
      
      // Preload next batch
      _preloadImages(nextBatch);
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load more pages: $e',
      );
      print('Error loading more pages: $e');
    }
  }

  Future<void> loadNextChapter() async {
    if (state.nextChapterId == null || state.isLoadingNextChapter) return;
    
    state = state.copyWith(isLoadingNextChapter: true);
    
    try {
      print('Loading next chapter: ${state.nextChapterId}');
      final pages = await repository.getPages(state.nextChapterId!, source: selectedSource);
      
      if (pages.isNotEmpty) {
        // Add pages from next chapter
        final List<MangaPage> updatedPages = [...state.pages, ...pages];
        
        // Update chapter index for future next chapter
        _currentChapterIndex++;
        String? nextNextChapterId;
        if (_currentChapterIndex < _allChapterIds.length - 1) {
          nextNextChapterId = _allChapterIds[_currentChapterIndex + 1];
        }
        
        state = state.copyWith(
          pages: updatedPages,
          isLoadingNextChapter: false,
          nextChapterId: nextNextChapterId,
          hasMore: nextNextChapterId != null,
        );
        
        // Preload first few pages of next chapter
        _preloadImages(pages.take(3).toList());
        
      } else {
        state = state.copyWith(
          isLoadingNextChapter: false,
          hasMore: false,
        );
      }
    } catch (e) {
      print('Error loading next chapter: $e');
      state = state.copyWith(
        isLoadingNextChapter: false,
        error: 'Failed to load next chapter: $e',
      );
    }
  }

  void resetReader() {
    _allPages = [];
    _pagesLoaded = false;
    state = ReaderState();
    loadPages();
  }
}

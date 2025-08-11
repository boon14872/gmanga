import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/reader_providers.dart';
import '../../../library/presentation/providers/library_providers.dart';

class MangaReaderScreen extends ConsumerStatefulWidget {
  const MangaReaderScreen({super.key});

  @override
  ConsumerState<MangaReaderScreen> createState() => _MangaReaderScreenState();
}

class _MangaReaderScreenState extends ConsumerState<MangaReaderScreen> 
    with TickerProviderStateMixin {
  late PageController _pageController;
  late String chapterId;
  String? mangaId;
  String? mangaTitle;
  List<String> chapterIds = [];
  late AnimationController _transitionController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _transitionController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      chapterId = args['chapterId'] as String;
      mangaId = args['mangaId'] as String?;
      mangaTitle = args['mangaTitle'] as String?;
      chapterIds = (args['chapterIds'] as List<String>?) ?? [];
      
      // Set manga context for auto-continue
      if (chapterIds.isNotEmpty) {
        Future.microtask(() {
          ref.read(readerProvider(chapterId).notifier).setMangaContext(mangaId, chapterIds);
        });
      }
    } else {
      chapterId = 'test_chapter_1';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    ref.read(currentPageProvider.notifier).state = page;
    
    // Update reading progress in library if manga is in library
    if (mangaId != null) {
      final libraryNotifier = ref.read(libraryProvider.notifier);
      if (libraryNotifier.isMangaInLibrary(mangaId!)) {
        libraryNotifier.updateLastReadChapter(mangaId!, 1);
      }
    }

    final readerState = ref.read(readerProvider(chapterId));
    
    // Load more pages when nearing the end of current chapter
    if (page >= readerState.pages.length - 3 && readerState.hasMore && !readerState.isLoadingNextChapter) {
      ref.read(readerProvider(chapterId).notifier).loadMorePages();
    }
    
    // Auto-continue to next chapter when reaching the end
    if (page >= readerState.pages.length - 1 && 
        readerState.nextChapterId != null && 
        !readerState.isLoadingNextChapter) {
      _showNextChapterDialog();
    }
  }

  void _showNextChapterDialog() {
    final readerState = ref.read(readerProvider(chapterId));
    if (readerState.nextChapterId == null) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('End of Chapter', style: TextStyle(color: Colors.white)),
        content: const Text(
          'You\'ve reached the end of this chapter. Continue to the next chapter?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to chapter list
            },
            child: const Text('Back to Chapters', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(readerProvider(chapterId).notifier).loadNextChapter();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: const Text('Continue', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _toggleFullscreen() {
    final isFullscreen = ref.read(isFullscreenProvider);
    ref.read(isFullscreenProvider.notifier).state = !isFullscreen;
    
    if (!isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _showPageJumpDialog() {
    final readerState = ref.read(readerProvider(chapterId));
    final currentPage = ref.read(currentPageProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Jump to Page'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current: ${currentPage + 1}/${readerState.pages.length}'),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Page number',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                final page = int.tryParse(value);
                if (page != null && page > 0 && page <= readerState.pages.length) {
                  _pageController.animateToPage(
                    page - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final readerState = ref.watch(readerProvider(chapterId));
    final currentPage = ref.watch(currentPageProvider);
    final isFullscreen = ref.watch(isFullscreenProvider);

    if (readerState.isLoading && readerState.pages.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (readerState.error != null && readerState.pages.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 64),
              const SizedBox(height: 16),
              Text(
                readerState.error!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(readerProvider(chapterId).notifier).resetReader();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: isFullscreen ? null : AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(mangaTitle ?? 'Manga Reader'),
        actions: [
          IconButton(
            onPressed: _showPageJumpDialog,
            icon: const Icon(Icons.list_alt),
          ),
          IconButton(
            onPressed: _toggleFullscreen,
            icon: Icon(isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen),
          ),
        ],
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _transitionController,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const BouncingScrollPhysics(),
              itemCount: readerState.pages.length + (readerState.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= readerState.pages.length) {
                  // Loading page for next chapter
                  return Container(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          readerState.isLoadingNextChapter 
                              ? 'Loading next chapter...'
                              : 'Loading more pages...',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }

                final page = readerState.pages[index];
                return GestureDetector(
                  onTap: _toggleFullscreen,
                  child: Container(
                    color: Colors.black,
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: Hero(
                        tag: 'manga_page_$index',
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: page.imageUrl,
                            fit: BoxFit.contain,
                            fadeInDuration: const Duration(milliseconds: 300),
                            fadeOutDuration: const Duration(milliseconds: 100),
                            placeholder: (context, url) => Container(
                              color: Colors.black,
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(color: Colors.white),
                                    SizedBox(height: 16),
                                    Text(
                                      'Loading image...',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.black,
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.red, size: 64),
                                    SizedBox(height: 16),
                                    Text(
                                      'Failed to load image',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Page indicator and controls
          if (!isFullscreen)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: currentPage > 0
                          ? () {
                              _pageController.animateToPage(
                                currentPage - 1,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOutCubic,
                              );
                            }
                          : null,
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    Text(
                      '${currentPage + 1} / ${readerState.pages.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      onPressed: currentPage < readerState.pages.length - 1
                          ? () {
                              _pageController.animateToPage(
                                currentPage + 1,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOutCubic,
                              );
                            }
                          : null,
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            
          // Enhanced loading indicator for better UX
          if (readerState.isLoading && readerState.pages.isNotEmpty)
            Positioned(
              top: 50,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      readerState.isLoadingNextChapter 
                          ? 'Loading next chapter...'
                          : 'Loading pages...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          // Chapter transition indicator
          if (readerState.nextChapterId != null && 
              currentPage >= readerState.pages.length - 3)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_stories, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Next chapter available! Swipe to continue reading.',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/reader_providers.dart';
import '../../../library/presentation/providers/library_providers.dart';
import '../../../../core/database/isar_service.dart';

class MangaReaderScreen extends ConsumerStatefulWidget {
  final String chapterId;
  final String? mangaTitle;

  const MangaReaderScreen({
    super.key,
    required this.chapterId,
    this.mangaTitle,
  });

  @override
  ConsumerState<MangaReaderScreen> createState() => _MangaReaderScreenState();
}

class _MangaReaderScreenState extends ConsumerState<MangaReaderScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late String chapterId;
  String? mangaId;
  String? mangaTitle;
  List<String> chapterIds = [];
  late AnimationController _transitionController;
  late AnimationController _uiController;
  int _currentPageIndex = 0;
  bool _isUIVisible = true;
  Timer? _hideUITimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _uiController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _transitionController.forward();
    _uiController.forward();

    // Listen to scroll changes to update current page
    _scrollController.addListener(_onScroll);

    // Start timer to hide UI
    _startHideUITimer();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _transitionController.dispose();
    _uiController.dispose();
    _hideUITimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Use parameters from widget instead of route arguments
    // Decode the chapter ID since it was encoded for URL safety
    chapterId = Uri.decodeComponent(widget.chapterId);
    mangaTitle = widget.mangaTitle;

    // Get additional parameters from route if available
    final route = ModalRoute.of(context);
    if (route != null) {
      final args = route.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        mangaId = args['mangaId'] as String?;
        chapterIds =
            (args['chapterIds'] as List<dynamic>?)?.cast<String>() ?? [];
      }
    }

    // Load initial pages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(readerProvider(chapterId).notifier).loadPages();
      _restoreReadingProgress(); // Restore reading position
    });
  }

  void _startHideUITimer() {
    _hideUITimer?.cancel();
    _hideUITimer = Timer(const Duration(seconds: 3), () {
      if (_isUIVisible && mounted) {
        setState(() {
          _isUIVisible = false;
        });
        _uiController.reverse();
      }
    });
  }

  void _showUI() {
    if (!_isUIVisible && mounted) {
      setState(() {
        _isUIVisible = true;
      });
      _uiController.forward();

      // Clear chapter end message when showing UI
      ref.read(readerProvider(chapterId).notifier).clearChapterEndMessage();
    }
    _startHideUITimer();
  }

  void _onScroll() {
    // Hide UI when scrolling
    if (_isUIVisible) {
      setState(() {
        _isUIVisible = false;
      });
      _uiController.reverse();
    }
    
    // Calculate current page index based on scroll position
    final readerState = ref.read(readerProvider(chapterId));
    if (readerState.pages.isNotEmpty && _scrollController.hasClients) {
      final screenHeight = MediaQuery.of(context).size.height;
      final scrollOffset = _scrollController.offset;
      
      // Calculate which page we're currently viewing
      final currentPageFromScroll = (scrollOffset / screenHeight).round();
      final clampedPage = currentPageFromScroll.clamp(0, readerState.pages.length - 1);
      
      if (clampedPage != _currentPageIndex) {
        setState(() {
          _currentPageIndex = clampedPage;
        });
        
        // Update the provider's current page
        ref.read(currentPageProvider.notifier).state = _currentPageIndex;
        
        // Call the existing page change logic
        _onPageChanged(_currentPageIndex);
      }
    }
  }

  void _onPageChanged(int page) {
    // Update reading progress in library if manga is in library
    if (mangaId != null) {
      final libraryNotifier = ref.read(libraryProvider.notifier);
      if (libraryNotifier.isMangaInLibrary(mangaId!)) {
        libraryNotifier.updateLastReadChapter(mangaId!, 1);
      }
    }

    final readerState = ref.read(readerProvider(chapterId));

    // Load more pages when nearing the end of current chapter
    if (page >= readerState.pages.length - 3 &&
        readerState.hasMore &&
        !readerState.isLoadingNextChapter) {
      ref.read(readerProvider(chapterId).notifier).loadMorePages();
    }

    // No manual dialog needed - auto-loading handles next chapter
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
                if (page != null &&
                    page > 0 &&
                    page <= readerState.pages.length) {
                  // Since we're using natural image heights, we need to calculate scroll position differently
                  // For now, we'll use an approximate calculation
                  final approxScrollPosition =
                      (page - 1) * (MediaQuery.of(context).size.height * 0.8);
                  _scrollController.animateTo(
                    approxScrollPosition,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                  Navigator.of(context).pop();
                  _showUI(); // Reset UI timer
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

  Future<void> _saveReadingProgress() async {
    try {
      final readerState = ref.read(readerProvider(chapterId));

      // Save reading progress using Isar - Fix: Use actual current page index
      await IsarService.instance.saveReadingProgress(
        mangaId: mangaId ?? 'unknown',
        mangaTitle: mangaTitle ?? 'Unknown Manga',
        chapterId: chapterId,
        chapterTitle:
            'Chapter $chapterId', // You can enhance this with actual chapter title
        currentPage: _currentPageIndex, // Use the tracked page index
        totalPages: readerState.pages.length,
      );
    } catch (e) {
      print('Error saving reading progress: $e');
    }
  }

  Future<void> _restoreReadingProgress() async {
    try {
      if (mangaId != null) {
        final progress = await IsarService.instance.getReadingProgress(mangaId!, chapterId);
        if (progress != null && _scrollController.hasClients) {
          // Wait a bit for the content to be loaded
          await Future.delayed(const Duration(milliseconds: 500));
          
          // Scroll to the saved position
          final targetPosition = progress.currentPage * MediaQuery.of(context).size.height;
          _scrollController.animateTo(
            targetPosition,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          
          setState(() {
            _currentPageIndex = progress.currentPage;
          });
        }
      }
    } catch (e) {
      print('Error restoring reading progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final readerState = ref.watch(readerProvider(chapterId));

    if (readerState.isLoading && readerState.pages.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return PopScope(
      canPop: false, // Prevent automatic pop
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Save current reading progress before going back
        await _saveReadingProgress();

        // Navigate back without confirmation
        if (context.mounted) {
          context.go('/manga/$mangaId');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Main content with smooth transition
            FadeTransition(
              opacity: _transitionController,
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollUpdateNotification) {
                    final readerState = ref.read(readerProvider(chapterId));

                    // Better page tracking based on scroll position
                    if (_scrollController.hasClients &&
                        readerState.pages.isNotEmpty) {
                      // Estimate current page based on scroll percentage
                      final maxScroll =
                          _scrollController.position.maxScrollExtent;
                      final currentScroll = _scrollController.offset;
                      final scrollPercentage = maxScroll > 0
                          ? currentScroll / maxScroll
                          : 0;
                      final estimatedPage =
                          (scrollPercentage * readerState.pages.length).floor();
                      final clampedPage = estimatedPage.clamp(
                        0,
                        readerState.pages.length - 1,
                      );

                      if (clampedPage != _currentPageIndex) {
                        _currentPageIndex = clampedPage;
                        ref.read(currentPageProvider.notifier).state =
                            clampedPage;
                        _onPageChanged(clampedPage);

                        // Check if we've reached the end of the chapter
                        ref
                            .read(readerProvider(chapterId).notifier)
                            .checkChapterEnd(clampedPage);
                      }

                      // Auto-load next chapter when scrolling near end (85% threshold)
                      if (scrollPercentage > 0.85 &&
                          readerState.nextChapterId != null &&
                          !readerState.isLoadingNextChapter) {
                        ref
                            .read(readerProvider(chapterId).notifier)
                            .loadNextChapter();
                      }
                    }
                  }

                  // Handle overscroll at end of chapter for next chapter loading
                  if (notification is OverscrollNotification) {
                    final readerState = ref.read(readerProvider(chapterId));

                    // Check if user is pulling up at the end of chapter (negative overscroll)
                    if (notification.overscroll < -10.0 && // Pull up gesture
                        _scrollController.position.pixels >=
                            _scrollController.position.maxScrollExtent -
                                50 && // Near end
                        readerState.nextChapterId != null &&
                        !readerState.isLoadingNextChapter) {
                      // Load next chapter when user pulls up at the end
                      ref
                          .read(readerProvider(chapterId).notifier)
                          .loadNextChapter();
                    }
                  }

                  return false;
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Manga pages with natural sizing (no black gaps)
                      ...readerState.pages.asMap().entries.map((entry) {
                        final index = entry.key;
                        final page = entry.value;

                        return Container(
                          width: double.infinity,
                          color: Colors.black,
                          child: GestureDetector(
                            onTap: _showUI, // Show UI on tap
                            child: InteractiveViewer(
                              minScale: 1.0,
                              maxScale: 4.0,
                              child: Hero(
                                tag: 'manga_page_$index',
                                child: CachedNetworkImage(
                                  imageUrl: page.imageUrl,
                                  fit: BoxFit
                                      .fitWidth, // Fit to screen width for webtoon-style reading
                                  width: double.infinity,
                                  fadeInDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  fadeOutDuration: const Duration(
                                    milliseconds: 100,
                                  ),
                                  placeholder: (context, url) => Container(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.6,
                                    color: Colors.black,
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Loading image...',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.6,
                                        color: Colors.black,
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red,
                                                size: 64,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                'Failed to load image',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),

                      // Loading indicator for more pages/next chapter
                      if (readerState.hasMore ||
                          readerState.isLoadingNextChapter)
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.5,
                          color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                readerState.isLoadingNextChapter
                                    ? 'Loading next chapter...'
                                    : 'Loading more pages...',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),

                      // Chapter end message and auto-loading indicator
                      if (readerState.isAtChapterEnd &&
                          readerState.chapterEndMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32.0),
                          color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                readerState.chapterEndMessage!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (readerState.nextChapterTitle != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  'Next: ${readerState.nextChapterTitle}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              if (readerState.showNextChapterHint) ...[
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Pull up to load next chapter',
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Animated top UI overlay (title and controls) - Fixed positioning
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _uiController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -100 * (1 - _uiController.value)),
                    child: Opacity(
                      opacity: _uiController.value,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    // Save current reading progress before going back
                                    await _saveReadingProgress();

                                    // Navigate back without confirmation
                                    if (context.mounted) {
                                      // Try to go back to the previous page, or go to browse if there's no previous page
                                      if (context.canPop()) {
                                        context.pop();
                                      } else {
                                        context.go('/browse');
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    mangaTitle ?? 'Manga Reader',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _showPageJumpDialog,
                                  icon: const Icon(
                                    Icons.list_alt,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Animated bottom UI overlay (page indicator and controls) - FIXED POSITIONING
            AnimatedBuilder(
              animation: _uiController,
              builder: (context, child) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Transform.translate(
                    offset: Offset(0, 100 * (1 - _uiController.value)),
                    child: Opacity(
                      opacity: _uiController.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Page progress indicator with accurate counting
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Builder(
                                    builder: (context) {
                                      // Calculate total pages more accurately
                                      int totalPages = readerState.pages.length;
                                      
                                      // Fix: More accurate page calculation
                                      int actualCurrentPage = _currentPageIndex;
                                      
                                      // If we're loading more content or next chapter, indicate that
                                      String pageText;
                                      if (readerState.isLoadingNextChapter) {
                                        pageText =
                                            '${actualCurrentPage + 1} / ${totalPages} (Loading...)';
                                      } else if (readerState.hasMore) {
                                        pageText =
                                            '${actualCurrentPage + 1} / ${totalPages}+';
                                      } else {
                                        pageText =
                                            '${actualCurrentPage + 1} / ${totalPages}';
                                      }

                                      return Text(
                                        pageText,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Navigation controls - Compact layout
                                SizedBox(
                                  height: 40, // Fixed height for controls
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        onPressed: _currentPageIndex > 0
                                            ? () {
                                                // Scroll up by one screen height
                                                final screenHeight =
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height;
                                                final currentOffset =
                                                    _scrollController.offset;
                                                final targetOffset =
                                                    (currentOffset - screenHeight)
                                                        .clamp(
                                                          0.0,
                                                          _scrollController
                                                              .position
                                                              .maxScrollExtent,
                                                        );
                                                _scrollController.animateTo(
                                                  targetOffset,
                                                  duration: const Duration(
                                                    milliseconds: 250,
                                                  ),
                                                  curve: Curves.easeInOutCubic,
                                                );
                                                _showUI(); // Reset UI timer
                                              }
                                            : null,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_up,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.white
                                              .withOpacity(0.2),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed:
                                            _currentPageIndex <
                                                readerState.pages.length - 1
                                            ? () {
                                                // Scroll down by one screen height
                                                final screenHeight =
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height;
                                                final currentOffset =
                                                    _scrollController.offset;
                                                final targetOffset =
                                                    (currentOffset + screenHeight)
                                                        .clamp(
                                                          0.0,
                                                          _scrollController
                                                              .position
                                                              .maxScrollExtent,
                                                        );
                                                _scrollController.animateTo(
                                                  targetOffset,
                                                  duration: const Duration(
                                                    milliseconds: 250,
                                                  ),
                                                  curve: Curves.easeInOutCubic,
                                                );
                                                _showUI(); // Reset UI timer
                                              }
                                            : null,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.white
                                              .withOpacity(0.2),
                                          padding: const EdgeInsets.all(8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
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

            // Chapter transition indicator with pull-up hint
            if (readerState.nextChapterId != null &&
                _currentPageIndex >= readerState.pages.length - 2 &&
                !readerState.isLoadingNextChapter)
              Positioned(
                top: 100,
                left: 20,
                right: 20,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_stories, color: Colors.white),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Next chapter available!',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Pull up to continue reading',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // Next chapter loading indicator
            if (readerState.isLoadingNextChapter)
              Positioned(
                top: 100,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Loading next chapter...',
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
      ), // End of Scaffold - this should be the child of PopScope
    ); // End of PopScope
  } // End of build method
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/reader_providers.dart';
import '../../../library/presentation/providers/library_providers.dart';
                    readerState.pages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final page = entry.value;
                      
                      return Container(
                        key: _pageKeys.length > index ? _pageKeys[index] : null,
                        width: double.infinity,
                        color: Colors.black,
                        child: GestureDetector(angaReaderScreen extends ConsumerStatefulWidget {
  const MangaReaderScreen({super.key});

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
  List<GlobalKey> _pageKeys = [];

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
    _scrollController.dispose();
    _transitionController.dispose();
    _uiController.dispose();
    _hideUITimer?.cancel();
    super.dispose();
  }

  void _startHideUITimer() {
    _hideUITimer?.cancel();
    _hideUITimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isUIVisible) {
        setState(() {
          _isUIVisible = false;
        });
        _uiController.reverse();
      }
    });
  }

  void _showUI() {
    if (!_isUIVisible) {
      setState(() {
        _isUIVisible = true;
      });
      _uiController.forward();
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
    
    // Calculate current page based on scroll position with better accuracy
    if (_scrollController.hasClients) {
      final readerState = ref.read(readerProvider(chapterId));
      if (readerState.pages.isNotEmpty) {
        // Find which page is currently most visible
        int visiblePage = 0;
        double maxVisibleHeight = 0;
        
        for (int i = 0; i < _pageKeys.length && i < readerState.pages.length; i++) {
          final context = _pageKeys[i].currentContext;
          if (context != null) {
            final box = context.findRenderObject() as RenderBox?;
            if (box != null) {
              final position = box.localToGlobal(Offset.zero);
              final size = box.size;
              final screenHeight = MediaQuery.of(context).size.height;
              
              // Calculate how much of this page is visible
              final topVisible = position.dy < 0 ? -position.dy : 0;
              final bottomVisible = position.dy + size.height > screenHeight 
                  ? screenHeight - position.dy 
                  : size.height;
              final visibleHeight = bottomVisible - topVisible;
              
              if (visibleHeight > maxVisibleHeight && visibleHeight > 0) {
                maxVisibleHeight = visibleHeight;
                visiblePage = i;
              }
            }
          }
        }
        
        if (visiblePage != _currentPageIndex) {
          _currentPageIndex = visiblePage;
          ref.read(currentPageProvider.notifier).state = visiblePage;
          _onPageChanged(visiblePage);
        }
        
        // Auto-load next chapter when near the end
        final scrollPercentage = _scrollController.offset / _scrollController.position.maxScrollExtent;
        if (scrollPercentage > 0.85 && 
            readerState.nextChapterId != null && 
            !readerState.isLoadingNextChapter) {
          ref.read(readerProvider(chapterId).notifier).loadNextChapter();
        }
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
    if (page >= readerState.pages.length - 3 && readerState.hasMore && !readerState.isLoadingNextChapter) {
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
                if (page != null && page > 0 && page <= readerState.pages.length) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  _scrollController.animateTo(
                    (page - 1) * screenHeight,
                    duration: const Duration(milliseconds: 500),
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

    // Initialize page keys if needed
    while (_pageKeys.length < readerState.pages.length) {
      _pageKeys.add(GlobalKey());
    }

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
      appBar: null, // Always hide app bar for immersive experience
      body: Stack(
        children: [
          FadeTransition(
            opacity: _transitionController,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollUpdateNotification) {
                  // Better page tracking during scroll
                  final screenHeight = MediaQuery.of(context).size.height;
                  final currentPage = (_scrollController.offset / screenHeight).round();
                  final readerState = ref.read(readerProvider(chapterId));
                  final clampedPage = currentPage.clamp(0, readerState.pages.length - 1);
                  
                  if (clampedPage != _currentPageIndex) {
                    _currentPageIndex = clampedPage;
                    ref.read(currentPageProvider.notifier).state = clampedPage;
                    _onPageChanged(clampedPage);
                  }
                  
                  // Auto-load next chapter when scrolling near end
                  if (_scrollController.position.maxScrollExtent > 0) {
                    final scrollPercentage = _scrollController.offset / _scrollController.position.maxScrollExtent;
                    if (scrollPercentage > 0.85 && 
                        readerState.nextChapterId != null && 
                        !readerState.isLoadingNextChapter) {
                      ref.read(readerProvider(chapterId).notifier).loadNextChapter();
                    }
                  }
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
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
                                fit: BoxFit.fitWidth, // Fit to screen width for webtoon-style reading
                                width: double.infinity,
                                fadeInDuration: const Duration(milliseconds: 300),
                                fadeOutDuration: const Duration(milliseconds: 100),
                                placeholder: (context, url) => Container(
                                  height: MediaQuery.of(context).size.height * 0.6,
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
                                  height: MediaQuery.of(context).size.height * 0.6,
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
                      );
                    }).toList(),
                    
                    // Loading indicator for more pages/next chapter
                    if (readerState.hasMore || readerState.isLoadingNextChapter)
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
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
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Animated top UI overlay (title and controls)
          AnimatedBuilder(
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
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
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
                              icon: const Icon(Icons.list_alt, color: Colors.white, size: 28),
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
          
          // Animated bottom UI overlay (page indicator and controls)
          AnimatedBuilder(
            animation: _uiController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 100 * (1 - _uiController.value)),
                child: Opacity(
                  opacity: _uiController.value,
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 120,
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
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Page progress indicator
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${currentPage + 1} / ${readerState.pages.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Navigation controls
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: currentPage > 0
                                        ? () {
                                            final screenHeight = MediaQuery.of(context).size.height;
                                            _scrollController.animateTo(
                                              (currentPage - 1) * screenHeight,
                                              duration: const Duration(milliseconds: 250),
                                              curve: Curves.easeInOutCubic,
                                            );
                                            _showUI(); // Reset UI timer
                                          }
                                        : null,
                                    icon: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 32),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      padding: const EdgeInsets.all(12),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: currentPage < readerState.pages.length - 1
                                        ? () {
                                            final screenHeight = MediaQuery.of(context).size.height;
                                            _scrollController.animateTo(
                                              (currentPage + 1) * screenHeight,
                                              duration: const Duration(milliseconds: 250),
                                              curve: Curves.easeInOutCubic,
                                            );
                                            _showUI(); // Reset UI timer
                                          }
                                        : null,
                                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      padding: const EdgeInsets.all(12),
                                    ),
                                  ),
                                ],
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

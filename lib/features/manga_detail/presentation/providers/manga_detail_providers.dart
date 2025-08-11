import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../browse/domain/manga.dart';
import '../../../browse/presentation/providers/manga_providers.dart';
import '../../../browse/presentation/providers/source_providers.dart';

// Manga detail state management
final mangaDetailProvider = StateNotifierProvider.family<MangaDetailNotifier, MangaDetailState, String>((ref, mangaId) {
  final repository = ref.read(mangaRepositoryProvider);
  final selectedSource = ref.read(selectedSourceProvider);
  return MangaDetailNotifier(mangaId, repository, selectedSource);
});

class MangaDetailState {
  final Manga? mangaDetail;
  final List<Chapter> chapters;
  final bool isLoadingDetail;
  final bool isLoadingChapters;
  final String? error;

  MangaDetailState({
    this.mangaDetail,
    this.chapters = const [],
    this.isLoadingDetail = false,
    this.isLoadingChapters = false,
    this.error,
  });

  MangaDetailState copyWith({
    Manga? mangaDetail,
    List<Chapter>? chapters,
    bool? isLoadingDetail,
    bool? isLoadingChapters,
    String? error,
  }) {
    return MangaDetailState(
      mangaDetail: mangaDetail ?? this.mangaDetail,
      chapters: chapters ?? this.chapters,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isLoadingChapters: isLoadingChapters ?? this.isLoadingChapters,
      error: error ?? this.error,
    );
  }
}

class MangaDetailNotifier extends StateNotifier<MangaDetailState> {
  final String mangaId;
  final repository;
  final selectedSource;

  MangaDetailNotifier(this.mangaId, this.repository, this.selectedSource) : super(MangaDetailState()) {
    print('MangaDetailNotifier initialized with:');
    print('- mangaId: $mangaId');
    print('- repository: $repository');
    print('- selectedSource: ${selectedSource?.name} (${selectedSource?.id})');
    loadMangaDetail();
    loadChapters();
  }

  Future<void> loadMangaDetail() async {
    state = state.copyWith(isLoadingDetail: true, error: null);
    
    try {
      print('Loading manga detail for ID: $mangaId');
      final detail = await repository.getMangaDetails(mangaId, source: selectedSource);
      
      print('Successfully loaded manga detail: ${detail.title}');
      state = state.copyWith(mangaDetail: detail, isLoadingDetail: false);
    } catch (e) {
      print('Error loading manga detail: $e');
      state = state.copyWith(
        isLoadingDetail: false,
        error: 'Failed to load manga details: $e',
      );
    }
  }

  Future<void> loadChapters() async {
    state = state.copyWith(isLoadingChapters: true);
    
    try {
      print('Loading chapters for manga ID: $mangaId');
      final chapters = await repository.getChapters(mangaId, source: selectedSource);
      
      print('Successfully loaded ${chapters.length} chapters');
      state = state.copyWith(chapters: chapters, isLoadingChapters: false);
    } catch (e) {
      print('Error loading chapters: $e');
      state = state.copyWith(
        isLoadingChapters: false,
        error: 'Failed to load chapters: $e',
      );
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      loadMangaDetail(),
      loadChapters(),
    ]);
  }
}

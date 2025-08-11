// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mangaRepositoryHash() => r'9c15e4491da5a44691b462ef75a4708a1ddbb961';

/// See also [mangaRepository].
@ProviderFor(mangaRepository)
final mangaRepositoryProvider = Provider<MangaRepository>.internal(
  mangaRepository,
  name: r'mangaRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mangaRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MangaRepositoryRef = ProviderRef<MangaRepository>;
String _$cacheServiceHash() => r'84442d4ee25bf8cce884bb123b7675291b9c2248';

/// See also [cacheService].
@ProviderFor(cacheService)
final cacheServiceProvider = Provider<CacheService>.internal(
  cacheService,
  name: r'cacheServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cacheServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CacheServiceRef = ProviderRef<CacheService>;
String _$mangaDetailsHash() => r'85452f03b9658ab3bd088ce5d4cd18380a4e074d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [mangaDetails].
@ProviderFor(mangaDetails)
const mangaDetailsProvider = MangaDetailsFamily();

/// See also [mangaDetails].
class MangaDetailsFamily extends Family<AsyncValue<Manga>> {
  /// See also [mangaDetails].
  const MangaDetailsFamily();

  /// See also [mangaDetails].
  MangaDetailsProvider call(
    String mangaId,
  ) {
    return MangaDetailsProvider(
      mangaId,
    );
  }

  @override
  MangaDetailsProvider getProviderOverride(
    covariant MangaDetailsProvider provider,
  ) {
    return call(
      provider.mangaId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mangaDetailsProvider';
}

/// See also [mangaDetails].
class MangaDetailsProvider extends AutoDisposeFutureProvider<Manga> {
  /// See also [mangaDetails].
  MangaDetailsProvider(
    String mangaId,
  ) : this._internal(
          (ref) => mangaDetails(
            ref as MangaDetailsRef,
            mangaId,
          ),
          from: mangaDetailsProvider,
          name: r'mangaDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mangaDetailsHash,
          dependencies: MangaDetailsFamily._dependencies,
          allTransitiveDependencies:
              MangaDetailsFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  MangaDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final String mangaId;

  @override
  Override overrideWith(
    FutureOr<Manga> Function(MangaDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MangaDetailsProvider._internal(
        (ref) => create(ref as MangaDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Manga> createElement() {
    return _MangaDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MangaDetailsProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MangaDetailsRef on AutoDisposeFutureProviderRef<Manga> {
  /// The parameter `mangaId` of this provider.
  String get mangaId;
}

class _MangaDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Manga> with MangaDetailsRef {
  _MangaDetailsProviderElement(super.provider);

  @override
  String get mangaId => (origin as MangaDetailsProvider).mangaId;
}

String _$chapterListHash() => r'67abae16dec269d2e7c471bc8f7009ebd55c2aeb';

/// See also [chapterList].
@ProviderFor(chapterList)
const chapterListProvider = ChapterListFamily();

/// See also [chapterList].
class ChapterListFamily extends Family<AsyncValue<List<Chapter>>> {
  /// See also [chapterList].
  const ChapterListFamily();

  /// See also [chapterList].
  ChapterListProvider call(
    String mangaId,
  ) {
    return ChapterListProvider(
      mangaId,
    );
  }

  @override
  ChapterListProvider getProviderOverride(
    covariant ChapterListProvider provider,
  ) {
    return call(
      provider.mangaId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chapterListProvider';
}

/// See also [chapterList].
class ChapterListProvider extends AutoDisposeFutureProvider<List<Chapter>> {
  /// See also [chapterList].
  ChapterListProvider(
    String mangaId,
  ) : this._internal(
          (ref) => chapterList(
            ref as ChapterListRef,
            mangaId,
          ),
          from: chapterListProvider,
          name: r'chapterListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chapterListHash,
          dependencies: ChapterListFamily._dependencies,
          allTransitiveDependencies:
              ChapterListFamily._allTransitiveDependencies,
          mangaId: mangaId,
        );

  ChapterListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mangaId,
  }) : super.internal();

  final String mangaId;

  @override
  Override overrideWith(
    FutureOr<List<Chapter>> Function(ChapterListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChapterListProvider._internal(
        (ref) => create(ref as ChapterListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mangaId: mangaId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Chapter>> createElement() {
    return _ChapterListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChapterListProvider && other.mangaId == mangaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mangaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChapterListRef on AutoDisposeFutureProviderRef<List<Chapter>> {
  /// The parameter `mangaId` of this provider.
  String get mangaId;
}

class _ChapterListProviderElement
    extends AutoDisposeFutureProviderElement<List<Chapter>>
    with ChapterListRef {
  _ChapterListProviderElement(super.provider);

  @override
  String get mangaId => (origin as ChapterListProvider).mangaId;
}

String _$browseSourceHash() => r'ee46461f8e885315b7cba8e7a62922a56a44ef46';

/// See also [BrowseSource].
@ProviderFor(BrowseSource)
final browseSourceProvider =
    AutoDisposeAsyncNotifierProvider<BrowseSource, List<Manga>>.internal(
  BrowseSource.new,
  name: r'browseSourceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$browseSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BrowseSource = AutoDisposeAsyncNotifier<List<Manga>>;
String _$latestSourceHash() => r'f22b9e1a16a03687979141940026d24483f7d3e3';

/// See also [LatestSource].
@ProviderFor(LatestSource)
final latestSourceProvider =
    AutoDisposeAsyncNotifierProvider<LatestSource, List<Manga>>.internal(
  LatestSource.new,
  name: r'latestSourceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$latestSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LatestSource = AutoDisposeAsyncNotifier<List<Manga>>;
String _$searchHash() => r'003f63408cd729e30c21132277e5cf45ea59f65f';

/// See also [Search].
@ProviderFor(Search)
final searchProvider =
    AutoDisposeAsyncNotifierProvider<Search, List<Manga>>.internal(
  Search.new,
  name: r'searchProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Search = AutoDisposeAsyncNotifier<List<Manga>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

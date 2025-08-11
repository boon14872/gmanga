// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availableSourcesHash() => r'bffa7cac301bd6b73898de59ae01b9a865120281';

/// See also [availableSources].
@ProviderFor(availableSources)
final availableSourcesProvider = Provider<List<MangaSource>>.internal(
  availableSources,
  name: r'availableSourcesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$availableSourcesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AvailableSourcesRef = ProviderRef<List<MangaSource>>;
String _$selectedSourceHash() => r'a7080b13af261dcd7ab70a4b86bcf6da1ba06700';

/// See also [SelectedSource].
@ProviderFor(SelectedSource)
final selectedSourceProvider =
    AutoDisposeNotifierProvider<SelectedSource, MangaSource>.internal(
  SelectedSource.new,
  name: r'selectedSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedSource = AutoDisposeNotifier<MangaSource>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

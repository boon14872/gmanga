import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:gmanga/features/browse/domain/manga.dart';
import 'package:gmanga/features/browse/domain/manga_repository.dart';
import 'package:gmanga/features/browse/domain/manga_source.dart';
import 'package:gmanga/features/reader/domain/manga_page.dart';

class JsMangaRepository implements MangaRepository {
  JavascriptRuntime? _runtime;
  String? _currentSourceId;
  final Dio _dio = Dio(BaseOptions(
    responseType: ResponseType.plain,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
  ));

  Future<void> _initRuntime({String? sourceAssetPath}) async {
    final assetPath = sourceAssetPath ?? 'assets/extensions/nekopost_source.js';
    
    if (_runtime == null || _currentSourceId != assetPath) {
      print("Switching to source: $assetPath (previous: $_currentSourceId)");
      
      if (_runtime != null) {
        _runtime = null;
      }
      
      _runtime = getJavascriptRuntime();
      _currentSourceId = assetPath;

      final jsCode = await rootBundle.loadString(assetPath);
      _runtime!.evaluate(jsCode);
      print("Extension code loaded from: $assetPath");
      
      // Create source instance
      _runtime!.evaluate("var source = new ${_getSourceClassName(assetPath)}();");
    }
  }
  
  String _getSourceClassName(String assetPath) {
    if (assetPath.contains('test_source')) return 'TestSource';
    if (assetPath.contains('nekopost_source')) return 'NekoPostSource';
    if (assetPath.contains('mangadx_source')) return 'MangaDxSource';
    if (assetPath.contains('comick_source')) return 'ComickSource';
    return 'UnknownSource';
  }

  Future<String> _evaluateJavascript(String methodCall, {String? sourceAssetPath}) async {
    await _initRuntime(sourceAssetPath: sourceAssetPath);
    print("Evaluating JS: $methodCall");
    try {
      final result = await _runtime!.evaluateAsync(methodCall);
      final out = result.stringResult;
      if (out.isEmpty) {
        print('JS returned empty string for: $methodCall');
      }
      return out;
    } catch (e) {
      print('JS evaluation error for $methodCall: $e');
      return '';
    }
  }

  @override
  Future<List<Manga>> getPopularManga(int page, {MangaSource? source}) async {
    final assetPath = source?.assetPath;
    
    // First, get the URL from JavaScript
    final urlJson = await _evaluateJavascript("source.getPopularUrl($page)", sourceAssetPath: assetPath);
    
    if (urlJson.trim().isEmpty) {
      print('Extension returned empty URL for getPopularUrl');
      return [];
    }
    
    String url;
    try {
      final urlData = jsonDecode(urlJson);
      url = urlData['url'] ?? '';
      if (url.isEmpty) {
        print('Extension returned invalid URL structure');
        return [];
      }
    } catch (e) {
      print('Failed to parse URL JSON from extension: $e');
      return [];
    }
    
    // Fetch the HTTP data in Dart
    print('Fetching URL from Dart: $url');
    final httpResponse = await _fetchHttpData(url, sourceAssetPath: assetPath);
    
    if (httpResponse.isEmpty) {
      print('Failed to fetch HTTP data for URL: $url');
      return [];
    }
    
    // Pass the HTTP response to JavaScript for parsing
    final resultJson = await _evaluateJavascript(
      "source.parsePopular(${jsonEncode(httpResponse)}, $page)", 
      sourceAssetPath: assetPath
    );
    
    if (resultJson.trim().isEmpty) {
      print('Extension returned empty result for parsePopular');
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(resultJson) as List<dynamic>;
      return decoded.map((item) => Manga(
        id: item['id'] ?? '',
        title: item['title'] ?? '',
        thumbnailUrl: item['thumbnailUrl'] ?? '',
      )).toList();
    } catch (e) {
      print('JSON decode error in getPopularManga. Raw: ${resultJson.substring(0, resultJson.length > 200 ? 200 : resultJson.length)}');
      return [];
    }
  }

  @override
  Future<List<Manga>> getLatestManga(int page, {MangaSource? source}) async {
    final assetPath = source?.assetPath;
    
    // First, get the URL from JavaScript
    final urlJson = await _evaluateJavascript("source.getLatestUrl ? source.getLatestUrl($page) : source.getPopularUrl($page)", sourceAssetPath: assetPath);
    
    if (urlJson.trim().isEmpty) {
      print('Extension returned empty URL for getLatestUrl');
      return [];
    }
    
    String url;
    try {
      final urlData = jsonDecode(urlJson);
      url = urlData['url'] ?? '';
      if (url.isEmpty) {
        print('Extension returned invalid URL structure');
        return [];
      }
    } catch (e) {
      print('Failed to parse URL JSON from extension: $e');
      return [];
    }
    
    // Fetch the HTTP data in Dart
    print('Fetching Latest URL from Dart: $url');
    final httpResponse = await _fetchHttpData(url, sourceAssetPath: assetPath);
    
    if (httpResponse.isEmpty) {
      print('Failed to fetch HTTP data for URL: $url');
      return [];
    }
    
    // Pass the HTTP response to JavaScript for parsing
    final resultJson = await _evaluateJavascript(
      "source.parseLatest ? source.parseLatest(${jsonEncode(httpResponse)}, $page) : source.parsePopular(${jsonEncode(httpResponse)}, $page)", 
      sourceAssetPath: assetPath
    );
    
    if (resultJson.trim().isEmpty) {
      print('Extension returned empty result for parseLatest');
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(resultJson) as List<dynamic>;
      return decoded.map((item) => Manga(
        id: item['id'] ?? '',
        title: item['title'] ?? '',
        thumbnailUrl: item['thumbnailUrl'] ?? '',
      )).toList();
    } catch (e) {
      print('JSON decode error in getLatestManga. Raw: ${resultJson.substring(0, resultJson.length > 200 ? 200 : resultJson.length)}');
      return [];
    }
  }

  @override
  Future<List<Manga>> searchManga(String query, {MangaSource? source, int page = 1}) async {
    final assetPath = source?.assetPath;
    
    // First, get the URL from JavaScript
    final urlJson = await _evaluateJavascript("source.getSearchUrl ? source.getSearchUrl(${jsonEncode(query)}, $page) : JSON.stringify({url: ''})", sourceAssetPath: assetPath);
    
    if (urlJson.trim().isEmpty) {
      print('Extension returned empty URL for getSearchUrl');
      return [];
    }
    
    String url;
    try {
      final urlData = jsonDecode(urlJson);
      url = urlData['url'] ?? '';
      if (url.isEmpty) {
        print('Extension returned invalid URL structure for search');
        return [];
      }
    } catch (e) {
      print('Failed to parse search URL JSON from extension: $e');
      return [];
    }
    
    // Fetch the HTTP data in Dart
    print('Fetching Search URL from Dart: $url');
    final httpResponse = await _fetchHttpData(url, sourceAssetPath: assetPath);
    
    if (httpResponse.isEmpty) {
      print('Failed to fetch HTTP data for search URL: $url');
      return [];
    }
    
    // Pass the HTTP response to JavaScript for parsing
    final resultJson = await _evaluateJavascript(
      "source.parseSearch ? source.parseSearch(${jsonEncode(httpResponse)}, ${jsonEncode(query)}, $page) : source.parsePopular(${jsonEncode(httpResponse)}, $page)", 
      sourceAssetPath: assetPath
    );
    
    if (resultJson.trim().isEmpty) {
      print('Extension returned empty result for parseSearch');
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(resultJson) as List<dynamic>;
      return decoded.map((item) => Manga(
        id: item['id'] ?? '',
        title: item['title'] ?? '',
        thumbnailUrl: item['thumbnailUrl'] ?? '',
      )).toList();
    } catch (e) {
      print('JSON decode error in searchManga. Raw: ${resultJson.substring(0, resultJson.length > 200 ? 200 : resultJson.length)}');
      return [];
    }
  }
  
  Future<String> _fetchHttpData(String url, {String? sourceAssetPath}) async {
    try {
      // Get headers from JavaScript extension instead of hardcoding
      Map<String, String> headers = {};
      try {
        final headersJson = await _evaluateJavascript("source.getHttpHeaders ? source.getHttpHeaders(${jsonEncode(url)}) : '{}'", sourceAssetPath: sourceAssetPath);
        if (headersJson.isNotEmpty && headersJson != '{}') {
          final headersData = jsonDecode(headersJson) as Map<String, dynamic>;
          headers = headersData.map((key, value) => MapEntry(key, value.toString()));
        }
      } catch (e) {
        print("Could not get headers from extension, using defaults: $e");
      }
      
      // Add default headers if not provided by extension
      headers.putIfAbsent('User-Agent', () => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36');
      headers.putIfAbsent('Accept', () => 'application/json, text/plain, */*');
      headers.putIfAbsent('Accept-Language', () => 'en-US,en;q=0.9');
      
      final response = await _dio.get(
        url,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      print("HTTP Success: ${response.statusCode}");
      final responseData = response.data as String;
      print("HTTP Response length: ${responseData.length}");
      return responseData;
    } catch (e) {
      print("HTTP Error: $e");
      return '';
    }
  }

  @override
  Future<Manga> getMangaDetails(String mangaId, {MangaSource? source}) async {
    final assetPath = source?.assetPath;
    
    // Use 2-step approach: get URL from JS, fetch HTTP in Dart, parse in JS
    final urlJson = await _evaluateJavascript("source.getDetailsUrl ? source.getDetailsUrl(${jsonEncode(mangaId)}) : JSON.stringify({url: ''})", sourceAssetPath: assetPath);
    
    String url = '';
    try {
      final urlData = jsonDecode(urlJson);
      url = urlData['url'] ?? '';
    } catch (e) {
      print('Could not get details URL from extension, trying direct approach: $e');
    }
    
    String httpResponse = '';
    if (url.isNotEmpty) {
      // Fetch HTTP data in Dart
      print('Fetching details URL from Dart: $url');
      httpResponse = await _fetchHttpData(url, sourceAssetPath: assetPath);
    }
    
    // Parse the response in JavaScript (with or without HTTP data)
    final resultJson = await _evaluateJavascript(
      httpResponse.isNotEmpty 
        ? "source.parseDetails ? source.parseDetails(${jsonEncode(httpResponse)}, ${jsonEncode(mangaId)}) : source.getDetails(${jsonEncode(mangaId)})"
        : "source.getDetails(${jsonEncode(mangaId)})", 
      sourceAssetPath: assetPath
    );
    
    if (resultJson.trim().isEmpty || resultJson.trim() == 'null') {
      print('Extension returned empty result for getMangaDetails');
      return Manga(id: mangaId, title: 'Unknown', thumbnailUrl: '');
    }
    
    try {
      final Map<String, dynamic> decoded = jsonDecode(resultJson) as Map<String, dynamic>;
      return Manga(
        id: decoded['id'] ?? mangaId,
        title: decoded['title'] ?? 'Unknown',
        thumbnailUrl: decoded['thumbnailUrl'] ?? '',
        author: decoded['author'],
        artist: decoded['artist'],
        description: decoded['description'],
        genres: List<String>.from((decoded['genres'] ?? const []) as List),
        status: decoded['status'],
      );
    } catch (e) {
      print('JSON decode error in getMangaDetails. Raw: ${resultJson.substring(0, resultJson.length > 200 ? 200 : resultJson.length)}');
      return Manga(id: mangaId, title: 'Unknown', thumbnailUrl: '');
    }
  }

  @override
  Future<List<Chapter>> getChapters(String mangaId, {MangaSource? source}) async {
    final assetPath = source?.assetPath;
    
    // Use 2-step approach: get URL from JS, fetch HTTP in Dart, parse in JS
    final urlJson = await _evaluateJavascript("source.getChaptersUrl ? source.getChaptersUrl(${jsonEncode(mangaId)}) : JSON.stringify({url: ''})", sourceAssetPath: assetPath);
    
    String url = '';
    try {
      final urlData = jsonDecode(urlJson);
      url = urlData['url'] ?? '';
    } catch (e) {
      print('Could not get chapters URL from extension, trying direct approach: $e');
    }
    
    String httpResponse = '';
    if (url.isNotEmpty) {
      // Fetch HTTP data in Dart
      print('Fetching chapters URL from Dart: $url');
      httpResponse = await _fetchHttpData(url, sourceAssetPath: assetPath);
    }
    
    // Parse the response in JavaScript (with or without HTTP data)
    final resultJson = await _evaluateJavascript(
      httpResponse.isNotEmpty 
        ? "source.parseChapters ? source.parseChapters(${jsonEncode(httpResponse)}, ${jsonEncode(mangaId)}) : source.getChapters(${jsonEncode(mangaId)})"
        : "source.getChapters(${jsonEncode(mangaId)})", 
      sourceAssetPath: assetPath
    );
    
    if (resultJson.trim().isEmpty) {
      print('Extension returned empty result for getChapters');
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(resultJson) as List<dynamic>;
      return decoded.map((item) => Chapter(
        id: item['id'] ?? '',
        name: item['title'] ?? item['name'] ?? '', // Try both 'title' and 'name'
        uploadDate: DateTime.tryParse(item['dateUploaded'] ?? item['uploadDate'] ?? '') ?? DateTime.now(), // Try both field names
      )).toList();
    } catch (e) {
      print('JSON decode error in getChapters. Raw: ${resultJson.substring(0, resultJson.length > 200 ? 200 : resultJson.length)}');
      return [];
    }
  }

  Future<List<MangaPage>> getPages(String chapterId, {MangaSource? source}) async {
    final assetPath = source?.assetPath;
    
    // Use 2-step approach: get URL from JS, fetch HTTP in Dart, parse in JS
    final urlJson = await _evaluateJavascript("source.getPagesUrl ? source.getPagesUrl(${jsonEncode(chapterId)}) : JSON.stringify({url: ''})", sourceAssetPath: assetPath);
    
    String url = '';
    try {
      final urlData = jsonDecode(urlJson);
      url = urlData['url'] ?? '';
    } catch (e) {
      print('Could not get pages URL from extension, trying direct approach: $e');
    }
    
    String httpResponse = '';
    if (url.isNotEmpty) {
      // Fetch HTTP data in Dart
      print('Fetching pages URL from Dart: $url');
      httpResponse = await _fetchHttpData(url, sourceAssetPath: assetPath);
    }
    
    // Parse the response in JavaScript (with or without HTTP data)
    final resultJson = await _evaluateJavascript(
      httpResponse.isNotEmpty 
        ? "source.parsePages ? source.parsePages(${jsonEncode(httpResponse)}, ${jsonEncode(chapterId)}) : source.getPages(${jsonEncode(chapterId)})"
        : "source.getPages(${jsonEncode(chapterId)})", 
      sourceAssetPath: assetPath
    );
    
    if (resultJson.trim().isEmpty) {
      print('Extension returned empty result for getPages');
      return [];
    }
    
    try {
      final List<dynamic> decoded = jsonDecode(resultJson) as List<dynamic>;
      return decoded.map((item) => MangaPage(
        id: '${chapterId}_${item['pageNumber'] ?? 0}',
        imageUrl: item['imageUrl'] ?? '',
        pageNumber: item['pageNumber'] ?? 0,
      )).toList();
    } catch (e) {
      print('JSON decode error in getPages. Raw: ${resultJson.substring(0, resultJson.length > 200 ? 200 : resultJson.length)}');
      return [];
    }
  }
}

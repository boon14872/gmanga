import 'package:flutter/material.dart';
import 'package:gmanga/features/browse/data/js_manga_repository.dart';
import 'package:gmanga/features/browse/domain/manga.dart';
import 'package:gmanga/features/browse/domain/manga_source.dart';

class SimpleTestPage extends StatefulWidget {
  const SimpleTestPage({Key? key}) : super(key: key);

  @override
  State<SimpleTestPage> createState() => _SimpleTestPageState();
}

class _SimpleTestPageState extends State<SimpleTestPage> {
  final JsMangaRepository _repository = JsMangaRepository();
  List<Manga> _manga = [];
  bool _isLoading = false;
  String _currentTest = '';

  Future<void> _testJSONPlaceholder() async {
    setState(() {
      _isLoading = true;
      _currentTest = 'Testing HTTP with Test Extension...';
    });

    try {
      final testSource = MangaSource(
        id: 'test',
        name: 'Test Source',
        assetPath: 'assets/extensions/test_source.js',
      );
      final result = await _repository.getPopularManga(1, source: testSource);
      setState(() {
        _manga = result;
        _currentTest = '✅ Test Extension Success! Got ${result.length} items';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentTest = '❌ Test Extension Failed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testNekoPost() async {
    setState(() {
      _isLoading = true;
      _currentTest = 'Testing NekoPost via JavaScript Extension...';
    });

    try {
      final nekopostSource = MangaSource(
        id: 'nekopost',
        name: 'NekoPost',
        assetPath: 'assets/extensions/nekopost_source.js',
      );
      final result = await _repository.getPopularManga(1, source: nekopostSource);
      setState(() {
        _manga = result;
        _currentTest = '✅ NekoPost Extension Success! Got ${result.length} items';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentTest = '❌ NekoPost Extension Failed: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testMangaDx() async {
    setState(() {
      _isLoading = true;
      _currentTest = 'Testing MangaDx via JavaScript Extension...';
    });

    try {
      final mangadxSource = MangaSource(
        id: 'mangadx',
        name: 'MangaDx',
        assetPath: 'assets/extensions/mangadx_source.js',
      );
      final result = await _repository.getPopularManga(1, source: mangadxSource);
      setState(() {
        _manga = result;
        _currentTest = '✅ MangaDx Extension Success! Got ${result.length} items';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentTest = '❌ MangaDx Extension Failed: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple API Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Extension Testing (JavaScript)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _testJSONPlaceholder,
                  child: const Text('Test Extension'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testNekoPost,
                  child: const Text('NekoPost JS'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testMangaDx,
                  child: const Text('MangaDx JS'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (_isLoading)
              const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Loading...'),
                ],
              ),
            
            if (_currentTest.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _currentTest,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            
            const SizedBox(height: 16),
            
            if (_manga.isNotEmpty) ...[
              Text(
                'Results (${_manga.length} items):',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _manga.length,
                  itemBuilder: (context, index) {
                    final manga = _manga[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              manga.thumbnailUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, color: Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                        title: Text(
                          manga.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (manga.author != null)
                              Text('Author: ${manga.author}'),
                            if (manga.description != null)
                              Text(
                                manga.description!.length > 100
                                    ? '${manga.description!.substring(0, 100)}...'
                                    : manga.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                        trailing: Text('ID: ${manga.id}'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

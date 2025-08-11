import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmanga/features/extensions/presentation/providers/extension_providers.dart';

class ExtensionManagementScreen extends ConsumerWidget {
  const ExtensionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extensionsAsync = ref.watch(extensionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extension Management'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _loadExtensionFromFile(context, ref),
                    icon: const Icon(Icons.file_upload),
                    label: const Text('Load from File'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showUrlImportDialog(context, ref),
                    icon: const Icon(Icons.link),
                    label: const Text('Import from URL'),
                  ),
                ),
              ],
            ),
          ),
          
          // Extensions list
          Expanded(
            child: extensionsAsync.when(
              data: (extensions) => ListView.builder(
                itemCount: extensions.length,
                itemBuilder: (context, index) {
                  final extension = extensions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: extension.isEnabled ? Colors.green : Colors.grey,
                        child: Text(
                          extension.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(extension.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Version: ${extension.version}'),
                          Text('Language: ${extension.lang}'),
                          Text('ID: ${extension.id}'),
                        ],
                      ),
                      trailing: Switch(
                        value: extension.isEnabled,
                        onChanged: (value) {
                          ref.read(extensionListProvider.notifier).toggle(extension.id);
                        },
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text('Error loading extensions: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(extensionListProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadExtensionFromFile(BuildContext context, WidgetRef ref) async {
    try {
      final extension = await ref.read(extensionListProvider.notifier).loadExtensionFromFile();
      
      if (extension != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully loaded extension: ${extension.name}'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load extension or operation was cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading extension: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showUrlImportDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Extension from URL'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Extension URL',
                hintText: 'https://example.com/extension.js',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Note: URL import is not yet implemented. Use file loading instead.',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(extensionListProvider.notifier).importFromUrl(urlController.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('URL import feature coming soon!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }
}

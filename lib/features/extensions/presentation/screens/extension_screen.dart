import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gmanga/features/extensions/presentation/providers/extension_providers.dart';
import 'package:gmanga/features/extensions/presentation/widgets/extension_list_item.dart';
import 'package:gmanga/shared/widgets/error_display.dart';

class ExtensionScreen extends ConsumerWidget {
  const ExtensionScreen({super.key});

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Import from URL'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'https://example.com/repo.json',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref
                      .read(extensionListProvider.notifier)
                      .importFromUrl(controller.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extensionsAsync = ref.watch(extensionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extensions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            tooltip: 'Load from File',
            onPressed: () => _loadExtensionFromFile(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.add_link),
            tooltip: 'Import from URL',
            onPressed: () => _showImportDialog(context, ref),
          ),
        ],
      ),
      body: extensionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorDisplay(
          error: error.toString(),
          onRetry: () => ref.invalidate(extensionListProvider),
        ),
        data: (extensions) {
          if (extensions.isEmpty) {
            return const Center(child: Text('No extensions installed.'));
          }
          return ListView.builder(
            itemCount: extensions.length,
            itemBuilder: (context, index) {
              final ext = extensions[index];
              return ExtensionListItem(
                extension: ext,
                onToggle: (newValue) {
                  ref.read(extensionListProvider.notifier).toggle(ext.id);
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _loadExtensionFromFile(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final extension = await ref
          .read(extensionListProvider.notifier)
          .loadExtensionFromFile();

      if (extension != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully loaded extension: ${extension.name}'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'VIEW',
              onPressed: () {
                // Extension is now in the list, user can see it
              },
            ),
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Operation cancelled or failed to load extension'),
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
}

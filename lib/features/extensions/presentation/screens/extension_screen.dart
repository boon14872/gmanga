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
    final extensionsState = ref.watch(extensionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Extensions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_link),
            tooltip: 'Import from URL',
            onPressed: () => _showImportDialog(context, ref),
          ),
        ],
      ),
      body: extensionsState.when(
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
}
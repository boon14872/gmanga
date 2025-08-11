import 'package:flutter/material.dart';
import 'package:gmanga/features/extensions/domain/extension_source.dart';

class ExtensionListItem extends StatelessWidget {
  final ExtensionSource extension;
  final ValueChanged<bool> onToggle;

  const ExtensionListItem({
    super.key,
    required this.extension,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.extension),
      title: Text(extension.name),
      subtitle: Text('v${extension.version} • ${extension.lang}'),
      trailing: Switch(
        value: extension.isEnabled,
        onChanged: onToggle,
      ),
    );
  }
}
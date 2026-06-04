import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';

/// Rounded monochrome search input used by Search and Bookmarks. Shows a clear
/// button only when there is text.
class SearchField extends StatelessWidget {
  const SearchField({
    required this.controller,
    required this.hint,
    this.onChanged,
    this.onClear,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colors.field,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 20, color: colors.muted),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              cursorColor: colors.accent,
              style: context.text.bodyMedium?.copyWith(color: colors.title),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: hint,
                hintStyle: context.text.bodyMedium?.copyWith(
                  color: colors.muted,
                ),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Icon(Icons.close_rounded, size: 18, color: colors.muted),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';

/// "Trending" / "Latest" row with an optional trailing action (See all, the
/// layout toggle).
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.action, super.key});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: context.text.titleMedium),
        ?action,
      ],
    );
  }
}

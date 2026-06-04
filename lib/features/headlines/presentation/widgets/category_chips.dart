import 'dart:async';

import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/theme/app_radius.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';

/// Horizontal category selector. The selected chip is a solid accent fill and
/// is reordered to the front so it never stays hidden off-screen.
class CategoryChips extends StatefulWidget {
  const CategoryChips({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final NewsCategory selected;
  final ValueChanged<NewsCategory> onSelected;

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  final _controller = ScrollController();

  @override
  void didUpdateWidget(CategoryChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected && _controller.hasClients) {
      unawaited(
        _controller.animateTo(
          0,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<NewsCategory> get _ordered => [
    widget.selected,
    ...NewsCategory.values.where((c) => c != widget.selected),
  ];

  @override
  Widget build(BuildContext context) {
    final ordered = _ordered;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: ordered.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = ordered[index];
          return _Chip(
            label: _labelFor(context, category),
            selected: category == widget.selected,
            onTap: () => widget.onSelected(category),
          );
        },
      ),
    );
  }

  String _labelFor(BuildContext context, NewsCategory category) {
    final l10n = context.l10n;
    return switch (category) {
      NewsCategory.general => l10n.categoryGeneral,
      NewsCategory.business => l10n.categoryBusiness,
      NewsCategory.entertainment => l10n.categoryEntertainment,
      NewsCategory.health => l10n.categoryHealth,
      NewsCategory.science => l10n.categoryScience,
      NewsCategory.sports => l10n.categorySports,
      NewsCategory.technology => l10n.categoryTechnology,
    };
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? colors.accent : colors.field,
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        child: Text(
          label,
          style: context.text.labelMedium?.copyWith(
            color: selected ? colors.onAccent : colors.body,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

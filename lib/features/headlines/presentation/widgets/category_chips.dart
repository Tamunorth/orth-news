import 'package:flutter/material.dart';
import 'package:orth_news/core/extensions/context_extensions.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/features/news/domain/entities/news_category.dart';

/// Horizontal category selector. The active chip is a solid accent pill.
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final NewsCategory selected;
  final ValueChanged<NewsCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: NewsCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = NewsCategory.values[index];
          return _Chip(
            label: _labelFor(context, category),
            selected: category == selected,
            onTap: () => onSelected(category),
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
          borderRadius: BorderRadius.circular(100),
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

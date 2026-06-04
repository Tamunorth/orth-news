import 'package:flutter/material.dart';
import 'package:orth_news/core/theme/app_colors.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 28,
        width: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          color: context.colors.accent,
        ),
      ),
    );
  }
}

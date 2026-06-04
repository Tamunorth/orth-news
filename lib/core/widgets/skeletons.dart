import 'package:flutter/material.dart';
import 'package:orth_news/core/theme/app_colors.dart';
import 'package:orth_news/core/theme/app_radius.dart';

/// Sweeps a soft highlight across the opaque shapes of [child].
class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, super.key});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = colors.field;
    final highlight = Color.alphaBlend(
      colors.muted.withValues(alpha: 0.16),
      base,
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            colors: [base, highlight, base],
            stops: const [0.35, 0.5, 0.65],
            transform: _SlideTransform(_controller.value),
          ).createShader(bounds),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlideTransform extends GradientTransform {
  const _SlideTransform(this.value);

  final double value;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues((value * 2 - 1) * bounds.width, 0, 0);
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.height, this.width, this.radius = AppRadius.field});

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.field,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Box(width: 84, height: 84),
          SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Box(height: 14, radius: 6),
                SizedBox(height: 8),
                _Box(width: 220, height: 12, radius: 6),
                SizedBox(height: 12),
                _Box(width: 120, height: 11, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading placeholder for the feed and search: an optional featured block
/// followed by a few list rows.
class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({this.featured = true, this.rows = 5, super.key});

  final bool featured;
  final int rows;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          if (featured) ...[
            const _Box(
              width: double.infinity,
              height: 190,
              radius: AppRadius.card,
            ),
            const SizedBox(height: 12),
            const _Box(width: double.infinity, height: 16, radius: 6),
            const SizedBox(height: 8),
            const _Box(width: 200, height: 14, radius: 6),
            const SizedBox(height: 20),
          ],
          for (var i = 0; i < rows; i++) const _RowSkeleton(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Jauge de progression circulaire animée.
/// Une fois `isCompleted` à true, elle se transforme en bouton "Recommencer"
/// (voir consigne "Navigation et rejouabilité").
class AnimatedGauge extends StatelessWidget {
  final double progress; // 0.0 -> 1.0
  final bool isCompleted;
  final VoidCallback onRestart;
  final double size;

  const AnimatedGauge({
    super.key,
    required this.progress,
    required this.isCompleted,
    required this.onRestart,
    this.size = 220,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: animation,
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: isCompleted
          ? _RestartButton(
              key: const ValueKey('restart'),
              size: size,
              onRestart: onRestart,
            )
          : _GaugeCircle(
              key: const ValueKey('gauge'),
              progress: progress,
              size: size,
            ),
    );
  }
}

class _GaugeCircle extends StatelessWidget {
  final double progress;
  final double size;

  const _GaugeCircle({super.key, required this.progress, required this.size});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Piste de fond
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 14,
              color: colorScheme.surfaceContainerHighest,
            ),
          ),
          // Progression animée
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0, 1)),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => SizedBox.expand(
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 14,
                strokeCap: StrokeCap.round,
                color: colorScheme.primary,
              ),
            ),
          ),
          // Pourcentage au centre
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0, 1)),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => Text(
              '${(value * 100).round()}%',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RestartButton extends StatelessWidget {
  final double size;
  final VoidCallback onRestart;

  const _RestartButton({super.key, required this.size, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: colorScheme.primary,
        shape: const CircleBorder(),
        elevation: 3,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onRestart,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_rounded, size: 48, color: colorScheme.onPrimary),
              const SizedBox(height: 8),
              Text(
                'Recommencer',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

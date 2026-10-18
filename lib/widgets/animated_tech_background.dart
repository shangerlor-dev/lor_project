
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedTechBackground extends StatefulWidget {
  final Widget child;

  const AnimatedTechBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedTechBackground> createState() =>
      _AnimatedTechBackgroundState();
}

class _AnimatedTechBackgroundState
    extends State<AnimatedTechBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080E1D),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF101D3A),
                    Color(0xFF080E1D),
                    Color(0xFF0C1930),
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: _TechBackgroundPainter(
                    progress: _controller.value,
                  ),
                );
              },
            ),
          ),

          // Soft blue light in the upper-right corner.
          Positioned(
            top: -130,
            right: -100,
            child: _GlowOrb(
              size: 330,
              color: const Color(0xFF176BFF).withValues(alpha: 0.19),
            ),
          ),

          // Teal light in the lower-left corner.
          Positioned(
            bottom: -150,
            left: -100,
            child: _GlowOrb(
              size: 350,
              color: const Color(0xFF20D9C3).withValues(alpha: 0.10),
            ),
          ),

          SafeArea(child: widget.child),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0.35),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _TechBackgroundPainter extends CustomPainter {
  final double progress;

  _TechBackgroundPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFF6DA5FF).withValues(alpha: 0.055)
      ..strokeWidth = 0.7;

    // Subtle technology grid.
    const spacing = 44.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Slowly moving particles.
    final random = math.Random(42);

    for (int i = 0; i < 48; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      final phase = (progress + i * 0.037) % 1.0;
      final y = (baseY - phase * 100) % size.height;

      final opacity =
          0.15 + 0.45 * (0.5 + 0.5 * math.sin(progress * 2 * math.pi + i));

      final particlePaint = Paint()
        ..color = (i.isEven
                ? const Color(0xFF4D8DFF)
                : const Color(0xFF35D6C4))
            .withValues(alpha: opacity.clamp(0.0, 0.6));

      canvas.drawCircle(
        Offset(baseX, y),
        i % 5 == 0 ? 2.0 : 1.1,
        particlePaint,
      );
    }

    // Fine, flowing light trails.
    final trailPaint = Paint()
      ..color = const Color(0xFF3478F6).withValues(alpha: 0.13)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(0, size.height * 0.72);
    path.cubicTo(
      size.width * 0.25,
      size.height * (0.60 + 0.025 * math.sin(progress * 2 * math.pi)),
      size.width * 0.52,
      size.height * 0.88,
      size.width,
      size.height * 0.66,
    );

    canvas.drawPath(path, trailPaint);
  }

  @override
  bool shouldRepaint(covariant _TechBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

import 'package:flutter/material.dart';

class Spotlight extends StatelessWidget {
  final Rect targetRect;
  final double padding;
  final Color overlayColor;

  const Spotlight({
    super.key,
    required this.targetRect,
    this.padding = 8.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.7),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen gesture blocker
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {}, // absorb tap
          child: Container(color: Colors.transparent),
        ),
        // The visual spotlight
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _SpotlightPainter(
            target: targetRect.inflate(padding),
            color: overlayColor,
          ),
        ),
        // An invisible box over the spotlight cutout that blocks taps
        Positioned(
          left: targetRect.left - padding,
          top: targetRect.top - padding,
          width: targetRect.width + 2 * padding,
          height: targetRect.height + 2 * padding,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {}, // absorb tap inside the spotlight hole
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect target;
  final Color color;

  _SpotlightPainter({required this.target, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..blendMode = BlendMode.dstOut;

    final overlayPaint = Paint()..color = color;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, overlayPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(target, const Radius.circular(12)),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

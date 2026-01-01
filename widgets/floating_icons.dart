import 'package:flutter/material.dart';
import 'dart:math' as math;

enum FloatingIconType {
  cat,
  dog,
  cloud,
  moon,
  star,
}

class FloatingIconWidget extends StatefulWidget {
  final FloatingIconType iconType;
  final double size;
  final bool isPulsing;
  final Color primaryColor;
  final Color secondaryColor;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const FloatingIconWidget({
    Key? key,
    required this.iconType,
    this.size = 80,
    this.isPulsing = false,
    this.primaryColor = const Color(0xFF7C3AED),
    this.secondaryColor = const Color(0xFFEAB308),
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<FloatingIconWidget> createState() => _FloatingIconWidgetState();
}

class _FloatingIconWidgetState extends State<FloatingIconWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isPulsing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FloatingIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing != oldWidget.isPulsing) {
      if (widget.isPulsing) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.primaryColor.withOpacity(0.3),
                    widget.secondaryColor.withOpacity(0.1),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating Ring
                  AnimatedBuilder(
                    animation: _rotateController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotateController.value * 2 * math.pi,
                        child: CustomPaint(
                          size: Size(widget.size, widget.size),
                          painter: RingPainter(
                            color1: widget.primaryColor,
                            color2: widget.secondaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                  // Icon
                  _buildIcon(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon() {
    switch (widget.iconType) {
      case FloatingIconType.cat:
        return _CatIcon(size: widget.size * 0.6, color: widget.primaryColor);
      case FloatingIconType.dog:
        return _DogIcon(size: widget.size * 0.6, color: widget.primaryColor);
      case FloatingIconType.cloud:
        return _CloudIcon(size: widget.size * 0.6, color: widget.primaryColor);
      case FloatingIconType.moon:
        return _MoonIcon(size: widget.size * 0.6, color: widget.primaryColor);
      case FloatingIconType.star:
        return _StarIcon(size: widget.size * 0.6, color: widget.primaryColor);
    }
  }
}

// Ring Painter for rotating effect
class RingPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  RingPainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..shader = LinearGradient(
        colors: [color1, color2],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2 - 5,
      paint,
    );

    // Draw small dots
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final x = size.width / 2 + math.cos(angle) * (size.width / 2 - 5);
      final y = size.height / 2 + math.sin(angle) * (size.height / 2 - 5);
      canvas.drawCircle(Offset(x, y), 2, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Cat Icon
class _CatIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _CatIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CatPainter(color: color),
    );
  }
}

class _CatPainter extends CustomPainter {
  final Color color;
  _CatPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Head
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.35,
      paint,
    );

    // Ears (triangles)
    final earPath1 = Path()
      ..moveTo(size.width * 0.25, size.height * 0.3)
      ..lineTo(size.width * 0.15, size.height * 0.1)
      ..lineTo(size.width * 0.35, size.height * 0.25)
      ..close();
    canvas.drawPath(earPath1, paint);

    final earPath2 = Path()
      ..moveTo(size.width * 0.75, size.height * 0.3)
      ..lineTo(size.width * 0.85, size.height * 0.1)
      ..lineTo(size.width * 0.65, size.height * 0.25)
      ..close();
    canvas.drawPath(earPath2, paint);

    // Eyes
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.45),
      size.width * 0.08,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.45),
      size.width * 0.08,
      eyePaint,
    );

    // Pupils
    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.45),
      size.width * 0.04,
      pupilPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.45),
      size.width * 0.04,
      pupilPaint,
    );

    // Nose
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.55),
      size.width * 0.05,
      Paint()..color = Colors.pink,
    );

    // Mouth
    final mouthPath = Path()
      ..moveTo(size.width * 0.5, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.65,
        size.width * 0.35,
        size.height * 0.6,
      );
    canvas.drawPath(
      mouthPath,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final mouthPath2 = Path()
      ..moveTo(size.width * 0.5, size.height * 0.55)
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.65,
        size.width * 0.65,
        size.height * 0.6,
      );
    canvas.drawPath(
      mouthPath2,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Dog Icon (ساده‌شده)
class _DogIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _DogIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.pets, size: size, color: color);
  }
}

// Cloud Icon
class _CloudIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _CloudIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CloudPainter(color: color),
    );
  }
}

class _CloudPainter extends CustomPainter {
  final Color color;
  _CloudPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Main cloud body
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.5), size.width * 0.2, paint);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4), size.width * 0.25, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.5), size.width * 0.2, paint);

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.5, size.width * 0.6, size.height * 0.2),
      Radius.circular(10),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Moon Icon
class _MoonIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _MoonIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _MoonPainter(color: color),
    );
  }
}

class _MoonPainter extends CustomPainter {
  final Color color;
  _MoonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width * 0.4))
      ..addOval(Rect.fromCircle(center: Offset(size.width * 0.6, size.height * 0.4), radius: size.width * 0.35))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Star Icon
class _StarIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _StarIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _StarPainter(color: color),
    );
  }
}

class _StarPainter extends CustomPainter {
  final Color color;
  _StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = size.width * 0.4;
    final innerRadius = size.width * 0.2;

    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * math.pi / 5) - math.pi / 2;
      final innerAngle = ((i * 2 + 1) * math.pi / 5) - math.pi / 2;

      if (i == 0) {
        path.moveTo(
          centerX + outerRadius * math.cos(outerAngle),
          centerY + outerRadius * math.sin(outerAngle),
        );
      } else {
        path.lineTo(
          centerX + outerRadius * math.cos(outerAngle),
          centerY + outerRadius * math.sin(outerAngle),
        );
      }

      path.lineTo(
        centerX + innerRadius * math.cos(innerAngle),
        centerY + innerRadius * math.sin(innerAngle),
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

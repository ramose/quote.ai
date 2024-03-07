import 'package:flutter/material.dart';
import 'dart:math' as math;

class GeminiLogo extends StatelessWidget {
  const GeminiLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(200, 200),
        painter: MyCustomPainter(),
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Define the points of the star
    const numberOfPoints = 5;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius / 2;
    const angle = (math.pi * 2) / numberOfPoints;
    const halfAngle = angle / 2;
    final center = Offset(size.width / 2, size.height / 2);

    // Move to the top of the star
    path.moveTo(center.dx, center.dy - outerRadius);

    for (int i = 1; i <= numberOfPoints; i++) {
      // Calculate outer point
      double x = center.dx + outerRadius * math.sin(i * angle);
      double y = center.dy - outerRadius * math.cos(i * angle);
      path.lineTo(x, y);

      // Calculate inner point
      x = center.dx + innerRadius * math.sin(i * angle + halfAngle);
      y = center.dy - innerRadius * math.cos(i * angle + halfAngle);
      path.lineTo(x, y);
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

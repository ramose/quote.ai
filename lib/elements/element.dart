import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';



class AmbientBackground extends StatefulWidget {
  @override
  _AmbientBackgroundState createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground> {
  double lightPosition = 0.0;
  double increment = 0.01;

  @override
  void initState() {
    super.initState();
    // Update the position of the light and reverse direction at edges
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        lightPosition += increment;
        if (lightPosition > 1.0 || lightPosition < 0.0) {
          increment = -increment;
          lightPosition += increment;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LightAndShadowPainter(lightPosition),
      child: Container(),
    );
  }
}

class LightAndShadowPainter extends CustomPainter {
  final double lightPosition;

  LightAndShadowPainter(this.lightPosition);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * lightPosition, size.height / 2);
    final radius = min(size.width, size.height) / 1;

    // Draw ambient light with radial gradient
    var gradient = RadialGradient(
      colors: [Color.fromARGB(155, 220, 219, 211).withAlpha(50), Colors.transparent],
      stops: [0.0, 1.0],
    );

    var rect = Rect.fromCircle(center: center, radius: radius);
    var paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawCircle(center, radius, paint);

    // Optionally, you can still draw shadows or other effects as needed.
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
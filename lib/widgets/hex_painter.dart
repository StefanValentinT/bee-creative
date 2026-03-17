import 'package:flutter/material.dart';
import 'package:open_simplex_noise/open_simplex_noise.dart';
import 'dart:math';

class HexPainter extends CustomPainter {
  final OpenSimplexNoise noise;
  static const double hexRadius = 15;
  static const double hexPadding = 5;
  static const List<Color> colors = [Color(0xFFFFD700), Color(0xFFFFEC8B)];
  static const Color strokeColor = Color(0xFFE0C200);
  static const double strokeWidth = 1;

  HexPainter(this.noise);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill..strokeWidth = strokeWidth;

    final hexHeight = sqrt(3) * hexRadius;
    final horizDist = 1.5 * hexRadius + hexPadding;
    final vertDist = (hexHeight * 0.75) + hexPadding * 3;
    final vertShift = vertDist / 2;

    final cols = (size.width / horizDist).ceil() + 4;
    final rows = (size.height / vertDist).ceil() + 4;

    final startX = -2 * horizDist + hexRadius + hexPadding / 2;
    final startY = -2 * vertDist + hexRadius + hexPadding / 2;

    for (int col = 0; col < cols; col++) {
      final offsetY = (col % 2) * vertShift;
      for (int row = 0; row < rows; row++) {
        final x = startX + col * horizDist;
        final y = startY + row * vertDist + offsetY;

        if (x + hexRadius < 0 || x - hexRadius > size.width) continue;
        if (y + hexRadius < 0 || y - hexRadius > size.height) continue;

        final n = noise.eval2D(col / 5, row / 5);
        if (n > 0.2) paint.color = colors[0];
        else if (n < -0.2) paint.color = colors[1];
        else continue;

        _drawHex(canvas, x, y, hexRadius, paint);
      }
    }
  }

  void _drawHex(Canvas canvas, double x, double y, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = pi / 3 * i;
      final px = x + radius * cos(angle);
      final py = y + radius * sin(angle);
      if (i == 0) path.moveTo(px, py);
      else path.lineTo(px, py);
    }
    path.close();
    canvas.drawPath(path, paint);
    
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = strokeColor
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
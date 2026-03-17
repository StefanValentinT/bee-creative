import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_simplex_noise/open_simplex_noise.dart';
import 'hex_painter.dart';

class CombinedHeader extends StatelessWidget {
  final OpenSimplexNoise noise;
  final String title;
  const CombinedHeader({super.key, required this.noise, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: Size.infinite, painter: HexPainter(noise)),
          Positioned(
            left: 0,
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: GoogleFonts.lobsterTwo(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
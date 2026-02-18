import 'package:flutter/material.dart';
import 'package:open_simplex_noise/open_simplex_noise.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeeCreative Social',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SocialHomePage(),
    );
  }
}

class SocialHomePage extends StatefulWidget {
  const SocialHomePage({super.key});

  @override
  State<SocialHomePage> createState() => _SocialHomePageState();
}

class _SocialHomePageState extends State<SocialHomePage> {
  final OpenSimplexNoise noise = OpenSimplexNoise(42);

  String selectedCommunity = "All";
  Map<String, bool> communityMuted = {
    "All": false,
    "Art": false,
    "Tech": false,
    "Flutter": false,
    "Gaming": false,
  };

  final List<Map<String, dynamic>> posts = [
    {"title": "New Flutter 3.4!", "community": "Flutter", "content": "Check out the new features...", "likes": 0, "dislikes": 0},
    {"title": "Game Release", "community": "Gaming", "content": "Awesome new RPG released!", "likes": 0, "dislikes": 0},
    {"title": "AI Art", "community": "Art", "content": "Look at this cool AI painting.", "likes": 0, "dislikes": 0},
    {"title": "Tech News", "community": "Tech", "content": "Big update from Apple today.", "likes": 0, "dislikes": 0},
  ];

  List<Map<String, dynamic>> get filteredPosts {
    return posts
        .where((p) => selectedCommunity == "All" || p["community"] == selectedCommunity)
        .where((p) => !communityMuted[p["community"]]!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildSidebar(),
      body: Column(
        children: [
          CombinedHeader(noise: noise, title: 'BeeCreative'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPosts.length,
              itemBuilder: (context, index) {
                final post = filteredPosts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(post["content"]),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.thumb_up, color: Colors.green),
                              onPressed: () {
                                setState(() => post["likes"]++);
                              },
                            ),
                            Text('${post["likes"]}'),
                            const SizedBox(width: 24),
                            IconButton(
                              icon: const Icon(Icons.thumb_down, color: Colors.red),
                              onPressed: () {
                                setState(() => post["dislikes"]++);
                              },
                            ),
                            Text('${post["dislikes"]}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Drawer buildSidebar() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Communities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: communityMuted.keys.map((community) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    leading: IconButton(
                      icon: Icon(
                        communityMuted[community]! ? Icons.notifications_off : Icons.notifications,
                        color: communityMuted[community]! ? Colors.grey : Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          communityMuted[community] = !communityMuted[community]!;
                        });
                      },
                    ),
                    title: Text(community),
                    selected: selectedCommunity == community,
                    onTap: () {
                      setState(() {
                        selectedCommunity = community;
                        Navigator.of(context).pop();
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
          CustomPaint(
            size: Size.infinite,
            painter: HexPainter(noise),
          ),
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
              textAlign: TextAlign.center,
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

class HexPainter extends CustomPainter {
  final OpenSimplexNoise noise;
  static const double hexRadius = 10;
  static const double hexPadding = 3;
  static const List<Color> colors = [Color(0xFFFFD700), Color(0xFFFFEC8B)];
  static const Color strokeColor = Color(0xFFE0C200);
  static const double strokeWidth = 1;

  HexPainter(this.noise);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth;

    final hexHeight = sqrt(3) * hexRadius;
    final horizDist = 1.5 * hexRadius + hexPadding;
    final vertDist = (hexHeight * 0.75) + hexPadding * 3;
    final vertShift = vertDist / 2;

    final extraCols = 2;
    final extraRows = 2;
    final cols = (size.width / horizDist).ceil() + extraCols * 2;
    final rows = (size.height / vertDist).ceil() + extraRows * 2;

    final startX = -extraCols * horizDist + hexRadius + hexPadding / 2;
    final startY = -extraRows * vertDist + hexRadius + hexPadding / 2;

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

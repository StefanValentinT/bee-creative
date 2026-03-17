import 'package:flutter/material.dart';
import 'package:open_simplex_noise/open_simplex_noise.dart';
import 'dart:math';
import 'dart:ui'; 
import 'models/mock_user.dart';
import 'social_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final OpenSimplexNoise noise = OpenSimplexNoise(42);

  final String storedName = "otto";
  final String storedPassword = "passwort";

  void login() {
    if (nameController.text.trim() == storedName && 
        passwordController.text.trim() == storedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SocialHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Falscher Name oder Passwort")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          Positioned.fill(
            child: CustomPaint(
              painter: HexPainter(noise),
            ),
          ),
          
          
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), 
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4), 
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "BeeCreative",
                            style: TextStyle(
                              fontSize: 32, 
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF8B4513),
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildTextField(nameController, "Accountname", Icons.person),
                          const SizedBox(height: 16),
                          _buildTextField(passwordController, "Passwort", Icons.lock, obscure: true),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFD700),
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text("Einloggen", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF8B4513)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.5), 
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class HexPainter extends CustomPainter {
  final OpenSimplexNoise noise;
  
  
  static const double hexRadius = 40; 
  static const double hexPadding = 4;
  
  static const List<Color> colors = [Color(0xFFFFD700), Color(0xFFFFEC8B)];
  static const Color strokeColor = Color(0xFFE0C200);
  static const double strokeWidth = 1.5;

  HexPainter(this.noise);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final hexHeight = sqrt(3) * hexRadius;
    final horizDist = 1.5 * hexRadius + hexPadding;
    final vertDist = hexHeight + (hexPadding * sqrt(3));
    
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = const Color(0xFFFFF9E3));

    for (int col = 0; col < (size.width / horizDist) + 2; col++) {
      for (int row = 0; row < (size.height / vertDist) + 2; row++) {
        double x = col * horizDist;
        double y = row * vertDist + (col % 2 == 1 ? vertDist / 2 : 0);

        final n = noise.eval2D(col / 8, row / 8);
        
        
        if (n > 0.1) paint.color = colors[0];
        else if (n < -0.1) paint.color = colors[1];
        else paint.color = const Color(0xFFFFFDF0);

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
      ..color = strokeColor.withOpacity(0.3)
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
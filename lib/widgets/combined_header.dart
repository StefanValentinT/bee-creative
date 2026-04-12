import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_simplex_noise/open_simplex_noise.dart';
import '../profile_page.dart';
import 'hex_painter.dart';

class CombinedHeader extends StatefulWidget {
  final OpenSimplexNoise noise;
  final String title;
  final VoidCallback onCreatePost;
  final Function(String) onSearch;

  const CombinedHeader({
    super.key,
    required this.noise,
    required this.title,
    required this.onCreatePost,
    required this.onSearch,
  });

  @override
  State<CombinedHeader> createState() => _CombinedHeaderState();
}

class _CombinedHeaderState extends State<CombinedHeader> {
  bool _isSearchOpen = false;
  bool _isMenuOpen = false;
  final TextEditingController _searchController = TextEditingController();

  void _toggleSearch() {
    if (_isMenuOpen) setState(() => _isMenuOpen = false);
    setState(() {
      _isSearchOpen = !_isSearchOpen;
      if (!_isSearchOpen) {
        _searchController.clear();
        widget.onSearch("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [

        if (_isMenuOpen)
          GestureDetector(
            onTap: () => setState(() => _isMenuOpen = false),
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
            ),
          ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(
              height: 80,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  ClipRect(
  child: CustomPaint(
    size: Size.infinite, 
    painter: HexPainter(widget.noise),
  ),
),

                  Positioned(
                    left: 12,
                    child: _CircleIconButton(
                      icon: Icons.menu,
                      onPressed: () {
                        setState(() => _isMenuOpen = false);
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),

                  Positioned(
                    left: 68,
                    child: Text(
                      widget.title,
                      style: GoogleFonts.lobsterTwo(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  Positioned(
                    right: 12,
                    child: Row(
                      children: [
                        _CircleIconButton(icon: Icons.search, onPressed: _toggleSearch),
                        const SizedBox(width: 8),
                        _CircleIconButton(
                          icon: Icons.add,
                          onPressed: () {
                            setState(() => _isMenuOpen = false);
                            widget.onCreatePost();
                          },
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        _CircleIconButton(
                          icon: Icons.more_vert,
                          onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: _isSearchOpen ? 70 : 0,
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _isSearchOpen
                  ? TextField(
                      controller: _searchController,
                      onChanged: widget.onSearch,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Search posts...",
                        prefixIcon: const Icon(Icons.search, color: Colors.orange),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: _toggleSearch,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),

        if (_isMenuOpen)
          Positioned(
            top: 85,
            right: 12,
            child: Material(
              elevation: 15,
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              child: Container(
                width: 220,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.orange),
                      title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Otto Normalverbraucher", style: TextStyle(fontSize: 12)),
                      onTap: () {
                        setState(() => _isMenuOpen = false);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                      },
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.privacy_tip, color: Colors.grey),
                      title: Text("Privacy", style: TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  const _CircleIconButton({required this.icon, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.9),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: IconButton(
        icon: Icon(icon, color: color ?? Colors.black87),
        onPressed: onPressed,
      ),
    );
  }
}
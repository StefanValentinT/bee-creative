import 'package:flutter/material.dart';

class PostImageCarousel extends StatefulWidget {
  final List<dynamic> images;
  final bool isFeed;
  final Function(String)? onImageTap;

  const PostImageCarousel({
    super.key, 
    required this.images, 
    this.isFeed = false,
    this.onImageTap,
  });

  @override
  State<PostImageCarousel> createState() => _PostImageCarouselState();
}

class _PostImageCarouselState extends State<PostImageCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigate(int delta) {
    _pageController.animateToPage(
      _currentIndex + delta,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [

          PageView.builder(
            controller: _pageController,
            physics: widget.isFeed 
                ? const NeverScrollableScrollPhysics() 
                : const BouncingScrollPhysics(),
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final img = widget.images[index];
              
              return GestureDetector(
                onTap: () {

                  if (!widget.isFeed && widget.onImageTap != null && img is String) {
                    widget.onImageTap!(img);
                  }
                },
                child: Container(
                  color: Colors.black.withOpacity(0.05),
                  child: img is String
                      ? Image.network(
                          img, 
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        )
                      : Image.memory(
                          img, 
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                ),
              );
            },
          ),

          if (!widget.isFeed && widget.images.length > 1) ...[
            _buildNavButton(
              icon: Icons.chevron_left, 
              left: 12, 
              onTap: () => _navigate(-1)
            ),
            _buildNavButton(
              icon: Icons.chevron_right, 
              right: 12, 
              onTap: () => _navigate(1)
            ),
          ],

          if (!widget.isFeed && widget.images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentIndex == index ? 20 : 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        )
                      ]
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon, 
    double? left, 
    double? right, 
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: 0,
      bottom: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.3),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
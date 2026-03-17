import 'package:flutter/material.dart';
import '../post_detail_page.dart';
import 'vote_buttons.dart'; 

class FeedPostPreview extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onUpdate;

  const FeedPostPreview({
    super.key, 
    required this.post, 
    required this.onUpdate
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostDetailPage(post: post, onUpdate: onUpdate),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post["community"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.orange, 
                      fontSize: 12
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post["title"], 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ],
              ),
            ),
            
            
            if (post["hasLocalImage"] == true)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/post_placeholder.jpg',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  post["content"],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),

            
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
              child: Row(
                children: [
                  FreeVoteButton(
                    likes: post["likes"],
                    onChanged: (v) {
                      post["likes"] += v;
                      onUpdate();
                    },
                  ),
                  const Spacer(),
                  const Text("💬", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    "${post["comments"].length} Kommentar(e)",
                    style: const TextStyle(
                      fontSize: 12, 
                      color: Colors.black45, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
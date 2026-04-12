import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../post_detail_page.dart';
import 'playful_actions.dart';

class FeedPostPreview extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onUpdate;

  const FeedPostPreview({super.key, required this.post, required this.onUpdate});

  @override
  State<FeedPostPreview> createState() => _FeedPostPreviewState();
}

class _FeedPostPreviewState extends State<FeedPostPreview> {

  late int _localLikes;
  int _userVote = 0;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _localLikes = widget.post["likes"] ?? 0;
  }

  void _handleVote(int direction) async {
    int oldVote = _userVote;
    int effectiveDirection = (_userVote == direction) ? 0 : direction;

    setState(() {
      _localLikes = _localLikes - oldVote + effectiveDirection;
      _userVote = effectiveDirection;
    });

    try {

      await _supabase
          .from('posts')
          .update({'likes': _localLikes})
          .eq('id', widget.post['id']);
      

      widget.onUpdate(); 
    } catch (e) {

      setState(() {
        _userVote = oldVote;
        _localLikes = _localLikes - effectiveDirection + oldVote;
      });
    }
  }

  String _getTruncatedContent(String content) {
    List<String> words = content.split(RegExp(r'\s+'));
    if (words.length <= 15) return content;
    return '${words.take(15).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    final List imageList = widget.post["image_urls"] ?? [];
    final int commentCount = (widget.post["comments"] as List?)?.length ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostDetailPage(post: widget.post, onUpdate: widget.onUpdate),
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
                    widget.post["community"]?.toUpperCase() ?? "GENERAL",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.orange,
                      fontSize: 10,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.post["title"] ?? "Untitled",
                    style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            if (imageList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageList[0],
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Text(
                _getTruncatedContent(widget.post["content"] ?? ""),
                style: TextStyle(color: Colors.grey[800], fontSize: 14, height: 1.4),
              ),
            ),
            

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 16, 16),
              child: Row(
                children: [

                  OptimisticVoteBar(
                    likes: _localLikes,
                    userVote: _userVote,
                    onVote: _handleVote,
                  ),
                  const Spacer(),
                  

                  PlayfulReplyButton(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PostDetailPage(post: widget.post, onUpdate: widget.onUpdate),
                      ),
                    ),
                    label: "$commentCount",
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
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/playful_actions.dart';
import 'widgets/comment_thread.dart';
import 'widgets/post_image_carousel.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onUpdate;
  const PostDetailPage({super.key, required this.post, required this.onUpdate});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool isReplyingPost = false;
  final TextEditingController _commentController = TextEditingController();
  final _supabase = Supabase.instance.client;

  late int _localLikes;
  int _userVote = 0;

  @override
  void initState() {
    super.initState();
    _localLikes = widget.post["likes"] ?? 0;
  }

  void _handlePostVote(int direction) async {
    int oldVote = _userVote;
    int effectiveDirection = (_userVote == direction) ? 0 : direction;

    setState(() {
      _localLikes = _localLikes - oldVote + effectiveDirection;
      _userVote = effectiveDirection;
    });

    try {
      await _supabase.from('posts').update({'likes': _localLikes}).eq('id', widget.post['id']);
      widget.onUpdate();
    } catch (e) {
      setState(() {
        _userVote = oldVote;
        _localLikes = _localLikes - effectiveDirection + oldVote;
      });
    }
  }

  Future<void> _addTopLevelComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final newComment = {
      "text": text,
      "likes": 0,
      "replies": [],
      "created_at": DateTime.now().toIso8601String(),
      "author": "Bee",
    };

    setState(() {
      widget.post["comments"] ??= [];
      widget.post["comments"].add(newComment);
      _commentController.clear();
      isReplyingPost = false;
    });

    try {
      await _supabase.from('posts').update({'comments': widget.post["comments"]}).eq('id', widget.post['id']);
      widget.onUpdate();
    } catch (e) {
      setState(() => widget.post["comments"].remove(newComment));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to post reply")));
    }
  }

  @override
  Widget build(BuildContext context) {
    List sortedComments = List.from(widget.post["comments"] ?? []);
    sortedComments.sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 202, 89),
        title: Text(widget.post["community"] ?? "Placeholder", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(widget.post["title"] ?? "", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          if (widget.post["image_urls"] != null)
            PostImageCarousel(images: widget.post["image_urls"], isFeed: false),
          const SizedBox(height: 20),
          MarkdownBody(data: widget.post["content"] ?? ""),
          const SizedBox(height: 25),
          
          Row(
            children: [
              OptimisticVoteBar(likes: _localLikes, userVote: _userVote, onVote: _handlePostVote),
              const SizedBox(width: 12),
              PlayfulReplyButton(
                onTap: () => setState(() => isReplyingPost = !isReplyingPost),
                isActive: isReplyingPost,
              ),
            ],
          ),

          if (isReplyingPost)
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextField(
                controller: _commentController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "What do you think...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                  suffixIcon: IconButton(icon: const Icon(Icons.send, color: Colors.orange), onPressed: _addTopLevelComment),
                ),
              ),
            ),
          
          const Divider(height: 40),
          ...sortedComments.map((c) => CommentThread(comment: c, depth: 0, onUpdate: widget.onUpdate)),
        ],
      ),
    );
  }
}
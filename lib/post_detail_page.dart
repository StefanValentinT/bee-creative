import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/playful_actions.dart';
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

  Future<void> _syncCommentsToBackend() async {
    try {
      await _supabase
          .from('posts')
          .update({'comments': widget.post["comments"]})
          .eq('id', widget.post['id']);
      widget.onUpdate();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sync to server: $e"))
      );
    }
  }

  void _handlePostVote(int direction) async {
    int oldVote = _userVote;
    int effectiveDirection = (_userVote == direction) ? 0 : direction;

    setState(() {
      _localLikes = _localLikes - oldVote + effectiveDirection;
      _userVote = effectiveDirection;
      widget.post["likes"] = _localLikes;
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

  void _addTopLevelComment() {
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

    _syncCommentsToBackend();
  }

  @override
  Widget build(BuildContext context) {
    List sortedComments = List.from(widget.post["comments"] ?? []);

    sortedComments.sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 202, 89),
        title: Text(widget.post["community"] ?? "Community", style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(widget.post["title"] ?? "", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          
          if (widget.post["image_urls"] != null && (widget.post["image_urls"] as List).isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: PostImageCarousel(images: widget.post["image_urls"], isFeed: false),
            ),
          
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
          const Text("Comments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          ...sortedComments.map((c) => CommentThread(
            comment: c, 
            depth: 0, 
            onSyncBackend: _syncCommentsToBackend
          )),
          
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class CommentThread extends StatefulWidget {
  final Map<String, dynamic> comment;
  final int depth;
  final VoidCallback onSyncBackend;

  const CommentThread({
    super.key,
    required this.comment,
    required this.depth,
    required this.onSyncBackend,
  });

  @override
  State<CommentThread> createState() => _CommentThreadState();
}

class _CommentThreadState extends State<CommentThread> {
  bool isReplying = false;
  final TextEditingController _replyCtrl = TextEditingController();

  late int _localLikes;
  int _userVote = 0;

  final List<Color> threadColors = [
    Colors.orange,
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.tealAccent[700]!,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    super.initState();
    _localLikes = widget.comment["likes"] ?? 0;
  }

  void _handleVote(int direction) {
    setState(() {
      int effectiveDirection = (_userVote == direction) ? 0 : direction;
      _localLikes = _localLikes - _userVote + effectiveDirection;
      _userVote = effectiveDirection;
      

      widget.comment["likes"] = _localLikes;
    });
    

    widget.onSyncBackend();
  }

  void _addNestedReply() {
    if (_replyCtrl.text.trim().isEmpty) return;

    setState(() {
      widget.comment["replies"] ??= [];
      widget.comment["replies"].add({
        "text": _replyCtrl.text.trim(),
        "likes": 0,
        "replies": [],
        "created_at": DateTime.now().toIso8601String(),
        "author": "Bee",
      });
      _replyCtrl.clear();
      isReplying = false;
    });

    widget.onSyncBackend();
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color currentLineColor = threadColors[widget.depth % threadColors.length];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.depth > 0)
            Container(
              width: 2.5,
              margin: EdgeInsets.only(
                left: (widget.depth * 10.0) - 5,
                right: 12,
                top: 4,
                bottom: 4,
              ),
              decoration: BoxDecoration(
                color: currentLineColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: MarkdownBody(
                    data: widget.comment["text"] ?? "",
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
                    ),
                  ),
                ),

                Row(
                  children: [
                    OptimisticVoteBar(
                      likes: _localLikes,
                      userVote: _userVote,
                      onVote: _handleVote,
                    ),
                    const SizedBox(width: 8),
                    PlayfulReplyButton(
                      onTap: () => setState(() => isReplying = !isReplying),
                      isActive: isReplying,
                    ),
                  ],
                ),

                if (isReplying)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12, top: 8, right: 10),
                    child: TextField(
                      controller: _replyCtrl,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Reply to comment",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: currentLineColor.withOpacity(0.3)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send_rounded, color: currentLineColor),
                          onPressed: _addNestedReply,
                        ),
                      ),
                    ),
                  ),

                if (widget.comment["replies"] != null && widget.comment["replies"].isNotEmpty)
                  Column(
                    children: (widget.comment["replies"] as List)
                        .map<Widget>((r) => CommentThread(
                              comment: r,
                              depth: widget.depth + 1,
                              onSyncBackend: widget.onSyncBackend,
                            ))
                        .toList(),
                  ),
                
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
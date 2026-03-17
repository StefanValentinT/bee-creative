import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'widgets/vote_buttons.dart';
import 'widgets/comment_thread.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onUpdate;
  const PostDetailPage({super.key, required this.post, required this.onUpdate});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  bool isReplyingPost = false;
  final TextEditingController _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List sortedComments = List.from(widget.post["comments"]);
    sortedComments.sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf1c232),
        title: Text(widget.post["community"], style: const TextStyle(color: Color(0xFFFFF9C4))),
        iconTheme: const IconThemeData(color: Color(0xFFFFF9C4)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(widget.post["title"], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (widget.post["hasLocalImage"] == true)
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/images/post_placeholder.jpg', fit: BoxFit.cover)),
          const SizedBox(height: 12),
          MarkdownBody(data: widget.post["content"]),
          Row(
            children: [
              FreeVoteButton(likes: widget.post["likes"], onChanged: (v) { setState(() => widget.post["likes"] += v); widget.onUpdate(); }),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => setState(() => isReplyingPost = !isReplyingPost),
                icon: const Text("💬", style: TextStyle(fontSize: 14)),
                label: const Text("Reply", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (isReplyingPost) 
            TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                suffixIcon: IconButton(icon: const Icon(Icons.send, color: Colors.blue), onPressed: () {
                  widget.post["comments"].add({"text": _ctrl.text, "likes": 0, "replies": []});
                  _ctrl.clear(); setState(() => isReplyingPost = false); widget.onUpdate();
                }),
              ),
            ),
          const Divider(height: 30),
          Column(children: sortedComments.map((c) => CommentThread(comment: c, depth: 0, onUpdate: () { setState(() {}); widget.onUpdate(); })).toList()),
        ],
      ),
    );
  }
}
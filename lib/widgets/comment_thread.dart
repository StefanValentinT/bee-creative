import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'vote_buttons.dart';

class CommentThread extends StatefulWidget {
  final Map<String, dynamic> comment;
  final int depth;
  final VoidCallback onUpdate;
  const CommentThread({super.key, required this.comment, required this.depth, required this.onUpdate});

  @override
  State<CommentThread> createState() => _CommentThreadState();
}

class _CommentThreadState extends State<CommentThread> {
  bool isReplying = false;
  final TextEditingController _replyCtrl = TextEditingController();

  
  final List<Color> threadColors = [
    Colors.orange,
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.tealAccent[700]!,
    Colors.pinkAccent,
  ];

  @override
  Widget build(BuildContext context) {
    
    final Color currentLineColor = threadColors[widget.depth % threadColors.length];

    return IntrinsicHeight( 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          if (widget.depth > 0)
            Container(
              width: 3, 
              margin: EdgeInsets.only(
                left: (widget.depth * 12.0) - 8, 
                right: 12,
                top: 4,
                bottom: 4
              ),
              decoration: BoxDecoration(
                color: currentLineColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: MarkdownBody(
                    data: widget.comment["text"],
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ),
                
                
                Row(
                  children: [
                    
                    FreeVoteButton(
                      likes: widget.comment["likes"], 
                      onChanged: (v) { 
                        widget.comment["likes"] += v; 
                        widget.onUpdate(); 
                      }
                    ),
                    const SizedBox(width: 4),
                    
                    
                    TextButton.icon(
                      style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                      onPressed: () => setState(() => isReplying = !isReplying),
                      icon: const Text("💬", style: TextStyle(fontSize: 16)),
                      label: const Text(
                        "Reply", 
                        style: TextStyle(
                          color: Colors.blue, 
                          fontWeight: FontWeight.w900, 
                          fontSize: 14
                        )
                      ),
                    ),
                  ],
                ),

                if (isReplying)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: TextField(
                      controller: _replyCtrl,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Write a reply...",
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.03),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send_rounded, color: Colors.blue, weight: 700), 
                          onPressed: () {
                            if (_replyCtrl.text.isEmpty) return;
                            widget.comment["replies"].add({"text": _replyCtrl.text, "likes": 0, "replies": []});
                            _replyCtrl.clear(); 
                            setState(() => isReplying = false); 
                            widget.onUpdate();
                          }
                        ),
                      ),
                    ),
                  ),

                
                if (widget.comment["replies"] != null)
                  Column(
                    children: widget.comment["replies"]
                        .map<Widget>((r) => CommentThread(
                              comment: r, 
                              depth: widget.depth + 1, 
                              onUpdate: widget.onUpdate
                            ))
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
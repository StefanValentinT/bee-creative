import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'vote_buttons.dart';

class CommentThread extends StatefulWidget {
  final Map<String, dynamic> comment;
  final int depth;
  final VoidCallback onUpdate;

  const CommentThread({
    super.key,
    required this.comment,
    required this.depth,
    required this.onUpdate,
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
    

    widget.onUpdate();
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

                    _PlayfulVoteWidget(
                      likes: _localLikes,
                      userVote: _userVote,
                      onVote: _handleVote,
                    ),
                    const SizedBox(width: 8),
                    

                    _PlayfulReplyButton(
                      onTap: () => setState(() => isReplying = !isReplying),
                      active: isReplying,
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
                          onPressed: () {
                            if (_replyCtrl.text.trim().isEmpty) return;
                            

                            widget.comment["replies"] ??= [];
                            widget.comment["replies"].add({
                              "text": _replyCtrl.text.trim(),
                              "likes": 0,
                              "replies": [],
                              "created_at": DateTime.now().toIso8601String(),
                            });
                            
                            _replyCtrl.clear();
                            setState(() => isReplying = false);
                            widget.onUpdate();
                          },
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
                              onUpdate: widget.onUpdate,
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

class _PlayfulVoteWidget extends StatelessWidget {
  final int likes;
  final int userVote;
  final Function(int) onVote;

  const _PlayfulVoteWidget({required this.likes, required this.userVote, required this.onVote});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_upward_rounded, 
              size: 18, 
              color: userVote == 1 ? Colors.orange : Colors.grey),
            onPressed: () => onVote(1),
          ),
          Text('$likes', style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: userVote == 1 ? Colors.orange : (userVote == -1 ? Colors.blue : Colors.black54),
          )),
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_downward_rounded, 
              size: 18, 
              color: userVote == -1 ? Colors.blue : Colors.grey),
            onPressed: () => onVote(-1),
          ),
        ],
      ),
    );
  }
}

class _PlayfulReplyButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool active;

  const _PlayfulReplyButton({required this.onTap, required this.active});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Text("💬", style: TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              "Reply",
              style: TextStyle(
                color: active ? Colors.blue : Colors.blueGrey,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class FreeVoteButton extends StatefulWidget {
  final int likes;
  final Function(int) onChanged;
  const FreeVoteButton({super.key, required this.likes, required this.onChanged});

  @override
  State<FreeVoteButton> createState() => _FreeVoteButtonState();
}

class _FreeVoteButtonState extends State<FreeVoteButton> {
  int userVote = 0;

  void _handleVote(int type) {
    int change = 0;
    if (userVote == type) {

      change = -type;
      userVote = 0;
    } else {

      change = type - userVote;
      userVote = type;
    }
    widget.onChanged(change);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _handleVote(1),
            icon: Icon(
              userVote == 1 ? Icons.arrow_upward_rounded : Icons.arrow_upward,
              color: userVote == 1 ? Colors.green : Colors.grey,
              fill: 1.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '${widget.likes}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: widget.likes >= 0 ? Colors.green[700] : Colors.red[800],
              ),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _handleVote(-1),
            icon: Icon(
              userVote == -1 ? Icons.arrow_downward_rounded : Icons.arrow_downward,
              color: userVote == -1 ? Colors.red : Colors.grey,
              fill: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
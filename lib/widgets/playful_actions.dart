import 'package:flutter/material.dart';

class PlayfulReplyButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isActive;
  final String label;

  const PlayfulReplyButton({
    super.key,
    required this.onTap,
    this.isActive = false,
    this.label = "Reply",
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.withOpacity(0.15) : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isActive ? "✨" : "💬", style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.blue : Colors.blueGrey[700],
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OptimisticVoteBar extends StatelessWidget {
  final int likes;
  final int userVote;
  final Function(int) onVote;

  const OptimisticVoteBar({
    super.key, 
    required this.likes, 
    required this.userVote, 
    required this.onVote
  });

  @override
  Widget build(BuildContext context) {

    Color backgroundColor = Colors.black.withOpacity(0.05);
    if (userVote == 1) backgroundColor = Colors.green;
    if (userVote == -1) backgroundColor = Colors.red;

    Color contentColor = Colors.black87;
    if (userVote == 1) contentColor = Colors.black;
    if (userVote == -1) contentColor = Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.arrow_upward_rounded, 
              color: userVote == 1 ? contentColor : Colors.grey[600]
            ),
            onPressed: () => onVote(1),
          ),
          Text(
            '$likes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: contentColor,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.arrow_downward_rounded, 
              color: userVote == -1 ? contentColor : Colors.grey[600]
            ),
            onPressed: () => onVote(-1),
          ),
        ],
      ),
    );
  }
}
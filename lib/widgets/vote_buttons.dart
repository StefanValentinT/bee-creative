import 'package:flutter/material.dart';

class FreeVoteButton extends StatelessWidget {
  final int likes;
  final Function(int) onChanged;
  const FreeVoteButton({super.key, required this.likes, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Color scoreBg = likes > 0 ? Colors.green.withOpacity(0.2) : (likes < 0 ? Colors.red.withOpacity(0.2) : Colors.black12);
    Color scoreText = likes > 0 ? Colors.green[700]! : (likes < 0 ? Colors.red[800]! : Colors.black54);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => onChanged(1),
          icon: const Icon(Icons.arrow_upward, size: 20, color: Colors.green),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(color: scoreBg, borderRadius: BorderRadius.circular(4)),
          child: Text('$likes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: scoreText)),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          onPressed: () => onChanged(-1),
          icon: const Icon(Icons.arrow_downward, size: 20, color: Colors.red),
        ),
      ],
    );
  }
}
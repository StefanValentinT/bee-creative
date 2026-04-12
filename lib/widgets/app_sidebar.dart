import 'package:flutter/material.dart';

class AppSidebar extends StatefulWidget {
  final List<String> communities;
  final Set<String> mutedCommunities;
  final Function(String) onToggleMute;

  const AppSidebar({
    super.key,
    required this.communities,
    required this.mutedCommunities,
    required this.onToggleMute,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFDF5E6),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Communities",
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFFB8860B)
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: widget.communities.length,
                itemBuilder: (context, index) {
                  final community = widget.communities[index];

                  final isMuted = widget.mutedCommunities.contains(community);

                  return ListTile(
                    title: Text(
                      community,
                      style: TextStyle(
                        color: isMuted ? Colors.grey : Colors.black87,
                        fontWeight: isMuted ? FontWeight.normal : FontWeight.w500,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        isMuted ? Icons.notifications_off_outlined : Icons.notifications_active,
                        color: isMuted ? Colors.grey : Colors.orange,
                      ),
                      onPressed: () {

                        widget.onToggleMute(community);
                        

                        setState(() {}); 
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
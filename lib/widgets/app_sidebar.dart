import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  final List<String> communities;
  final Set<String> selectedCommunities;
  final Set<String> mutedCommunities;
  final Function(String) onToggleSelect;
  final Function(String) onToggleMute;

  const AppSidebar({
    super.key,
    required this.communities,
    required this.selectedCommunities,
    required this.mutedCommunities,
    required this.onToggleSelect,
    required this.onToggleMute,
  });

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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFB8860B)),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: communities.length,
                itemBuilder: (context, index) {
                  final community = communities[index];
                  final isMuted = mutedCommunities.contains(community);
                  final isSelected = selectedCommunities.contains(community);

                  return ListTile(
                    leading: IconButton(
                      icon: Icon(
                        isMuted ? Icons.notifications_off : Icons.notifications_active,
                        color: isMuted ? Colors.grey : Colors.orange,
                      ),
                      onPressed: () => onToggleMute(community),
                    ),
                    title: Text(
                      community,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isMuted ? Colors.grey : Colors.black87,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.orange, size: 20) : null,
                    onTap: () => onToggleSelect(community),
                    selected: isSelected,
                    selectedTileColor: Colors.orange.withOpacity(0.1),
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
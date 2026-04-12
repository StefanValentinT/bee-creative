import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:open_simplex_noise/open_simplex_noise.dart';

import 'widgets/combined_header.dart';
import 'widgets/feed_post_preview.dart';
import 'widgets/create_post_dialog.dart';
import 'widgets/app_sidebar.dart';

class SocialHomePage extends StatefulWidget {
  const SocialHomePage({super.key});

  @override
  State<SocialHomePage> createState() => _SocialHomePageState();
}

class _SocialHomePageState extends State<SocialHomePage> {
  final OpenSimplexNoise noise = OpenSimplexNoise(42);
  final _supabase = Supabase.instance.client;
  String _searchQuery = "";

  final List<String> _communities = ['General', 'BeeCreative', 'Linux', 'Math', 'Kunst', 'Photographie'];
  Set<String> _mutedCommunities = {};

  void _toggleMute(String community) {
    setState(() {

      final newMuted = Set<String>.from(_mutedCommunities);

      if (newMuted.contains(community)) {
        newMuted.remove(community);
      } else {
        newMuted.add(community);
      }

      _mutedCommunities = newMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      

      drawer: AppSidebar(
        communities: _communities,
        mutedCommunities: _mutedCommunities,
        onToggleMute: _toggleMute,
      ),

      body: SafeArea(
        child: Stack(
          children: [

            Column(
              children: [
                const SizedBox(height: 80), 
                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _supabase.from('posts').stream(primaryKey: ['id']).order('created_at'),
                    builder: (context, snapshot) {
  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

  final filteredPosts = snapshot.data!.where((post) {
    final title = post['title']?.toString().toLowerCase() ?? "";
    final community = post['community']?.toString() ?? "General";
    

    bool matchesSearch = title.contains(_searchQuery.toLowerCase());
    

    bool isNotMuted = !_mutedCommunities.contains(community);

    return matchesSearch && isNotMuted;
  }).toList();

  return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredPosts.length,
                        itemBuilder: (context, index) => FeedPostPreview(
                          post: filteredPosts[index],
                          onUpdate: () {},
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: CombinedHeader(
                noise: noise,
                title: 'BeeCreative',
                onCreatePost: () => showDialog(
                  context: context,
                  builder: (context) => const CreatePostDialog(),
                ),
                onSearch: (val) => setState(() => _searchQuery = val),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
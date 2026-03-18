import 'package:bee_creative_flutter/widgets/feed_post_preview.dart';
import 'package:flutter/material.dart';
import 'package:open_simplex_noise/open_simplex_noise.dart';
import 'widgets/combined_header.dart';
import 'widgets/app_sidebar.dart';
import 'post_detail_page.dart';

class SocialHomePage extends StatefulWidget {
  const SocialHomePage({super.key});

  @override
  State<SocialHomePage> createState() => _SocialHomePageState();
}

class _SocialHomePageState extends State<SocialHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Set<String> selectedCommunities = {};
  final Set<String> mutedCommunities = {};
  final OpenSimplexNoise noise = OpenSimplexNoise(42);

  final List<Map<String, dynamic>> posts = [
    {
      "title": "Mein neues Bild",
      "community": "Kunst & Künstler",
      "content": "Gefällt es euch? Ich habe gestern dieses Bild gemalt.",
      "hasLocalImage": true,
      "likes": 120,
      "comments": [
        {
          "text": "Sieht echt gut aus!",
          "likes": 5,
          "replies": [
            {"text": "Finde ich auch 👍", "likes": 2, "replies": []}
          ]
        },
        {
          "text": "Du könntes in Rom anfangen.",
          "likes": 10,
          "replies": [
            
          ]
        }
      ]
    },
    {
      "title": "Nix ist der beste Paketmanager.",
      "community": "Computer",
      "content": "Ganz offensichtlich.",
      "hasLocalImage": false,
      "likes": 100,
      "comments": [
        {"text": "Stimme zu. Jetzt dauert zwar alles Stunden zum Installieren, dafür ist mein Packagemanager mit _formal-bewiesenen_ Semantiken ausgestattet.", "likes": 10, "replies": []}
      ]
    },
    {
      "title": "Wille zur Macht?",
      "community": "Phi",
      "content": "Schopenhauer sieht den 'Willen' als Quelle des Leidens, die wir verneinen müssen, der Nietzsche den unbedingten 'Willen zur Macht' gegenübersetzt. Wie lässt sich der Konflikt lösen?",
      "hasLocalImage": false,
      "likes": 42,
      "comments": [
        {"text": "Nietzsches Bejahung ist von viel größerem theoretischen Anspruch..", "likes": 8, "replies": []}
      ]
    },
    {
      "title": "Hyprland, bester Wayland-Window-Manager?"
      "community": "Linux Ricing",
      "content": "Hyprland hat viele enormst unnötige Animationen- außerdem sind die config-files unübersichtlich und die Community toxisch. Alles in allem die vollkommene Verkörperung einer Cyberpunk-Dystopie. Der beste Window-Manager der jemals erstellt wurde!!!",
      "hasLocalImage": false,
      "likes": 54,
      "comments": [
        {"text": "Du hast wohl noch nie von i3 gehört...", "likes": 8, "replies": []}
      ]
    },
  ];

  List<String> get communities => posts.map((p) => p["community"] as String).toSet().toList();

  
  List<Map<String, dynamic>> get filteredPosts {
    
    List<Map<String, dynamic>> list = posts.where((p) {
      final c = p["community"] as String;
      if (mutedCommunities.contains(c)) return false;
      if (selectedCommunities.isEmpty) return true;
      return selectedCommunities.contains(c);
    }).toList();

    
    list.sort((a, b) => (b["likes"] as int).compareTo(a["likes"] as int));
    
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFDF5E6),
      drawer: AppSidebar(
        communities: communities,
        selectedCommunities: selectedCommunities,
        mutedCommunities: mutedCommunities,
        onToggleSelect: (c) => setState(() => selectedCommunities.contains(c) ? selectedCommunities.remove(c) : selectedCommunities.add(c)),
        onToggleMute: (c) => setState(() => mutedCommunities.contains(c) ? mutedCommunities.remove(c) : mutedCommunities.add(c)),
      ),
      
body: SafeArea(
  child: Column(
    children: [
      CombinedHeader(noise: noise, title: 'BeeCreative'),
      
      const SizedBox(height: 8), 
      Expanded(
        child: ListView.builder(
          
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20), 
          itemCount: filteredPosts.length,
          itemBuilder: (context, index) => FeedPostPreview(
            post: filteredPosts[index], 
            onUpdate: () => setState(() {})
          ),
        ),
      ),
    ],
  ),
),
    );
  }
}

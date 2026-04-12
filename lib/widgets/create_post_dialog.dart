import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({super.key});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCommunity = 'General';
  final List<XFile> _imageFiles = [];
  bool _isUploading = false;

  final List<String> _communities = ['General', 'BeeCreative', 'Linux', 'Math', 'MathMemes', 'Kunst', 'Philosophie', 'Malerei', 'Photographie'];

  Future<void> _pickImages() async {
    final List<XFile> selected = await ImagePicker().pickMultiImage(imageQuality: 70);
    if (selected.isNotEmpty) setState(() => _imageFiles.addAll(selected));
  }

  Future<void> _submitPost() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() => _isUploading = true);
    final supabase = Supabase.instance.client;

    try {
      List<String> urls = [];
      for (var f in _imageFiles) {
        final path = 'public/${DateTime.now().microsecondsSinceEpoch}.jpg';
        await supabase.storage.from('post-images').uploadBinary(path, await f.readAsBytes());
        urls.add(supabase.storage.from('post-images').getPublicUrl(path));
      }
      await supabase.from('posts').insert({
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'community': _selectedCommunity,
        'image_urls': urls,
        'likes': 0, 'comments': [],
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 800),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(20), child: Text("Create Post", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      menuMaxHeight: 250,
                      borderRadius: BorderRadius.circular(15),
                      value: _selectedCommunity,
                      decoration: _inputStyle("Community"),
                      items: _communities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) => setState(() => _selectedCommunity = val!),
                    ),
                    const SizedBox(height: 15),
                    TextField(controller: _titleController, decoration: _inputStyle("Title")),
                    const SizedBox(height: 15),
                    TextField(controller: _contentController, maxLines: 10, decoration: _inputStyle("Content")),
                    const SizedBox(height: 20),
                    
                    if (_imageFiles.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        children: _imageFiles.map((f) => Stack(
                          children: [
                            Container(width: 70, height: 70, decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green, width: 2)), child: const Icon(Icons.image, color: Colors.grey)),
                            const Positioned(right: 2, top: 2, child: Icon(Icons.check_circle, color: Colors.green, size: 18)),
                          ],
                        )).toList(),
                      ),
                    const SizedBox(height: 10),
                    TextButton.icon(onPressed: _pickImages, icon: const Icon(Icons.add_a_photo), label: const Text("Add images")),
                  ],
                ),
              ),
            ),
            Padding(
  padding: const EdgeInsets.all(20),
  child: Row(
    children: [

      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.close, color: Colors.grey, size: 28),
      ),
      const SizedBox(width: 8),

      Expanded(
        child: ElevatedButton(
          onPressed: _isUploading ? null : _submitPost,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isUploading 
              ? const CircularProgressIndicator(color: Colors.white) 
              : const Text("Post", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    ],
  ),
),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
  );
}
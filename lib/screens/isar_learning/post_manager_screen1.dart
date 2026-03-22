import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/user3.dart';
import 'package:flutter2/models/post1.dart';

class PostManagerScreen extends StatefulWidget {
  final Isar isar;
  const PostManagerScreen({super.key, required this.isar});

  @override
  State<PostManagerScreen> createState() => _PostManagerScreenState();
}

class _PostManagerScreenState extends State<PostManagerScreen> {
  User3? user;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = ModalRoute.of(context)!.settings.arguments as int;
    _loadUser(userId);
  }

  void _loadUser(int id) async {
    final result = await widget.isar.user3s.get(id);
    if (result != null) {
      await result.posts.load(); 
      setState(() => user = result);
    }
  }

  void _addPost() async {
    if (user == null || _titleController.text.isEmpty) return;

    final newPost = Post1()
      ..title = _titleController.text
      ..content = _contentController.text;

    await widget.isar.writeTxn(() async {
      await widget.isar.post1s.put(newPost);
      user!.posts.add(newPost);
      await user!.posts.save();
    });

    _titleController.clear();
    _contentController.clear();
    _loadUser(user!.id); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Posts for ${user?.name ?? '...'}")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(controller: _titleController, decoration: const InputDecoration(hintText: "Post Title")),
                TextField(controller: _contentController, decoration: const InputDecoration(hintText: "Post Content")),
                ElevatedButton(onPressed: _addPost, child: const Text("Create Post & Link to User")),
              ],
            ),
          ),
          Expanded(
            child: user == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: user!.posts.length,
                    itemBuilder: (context, i) {
                      final post = user!.posts.elementAt(i);
                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.content),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
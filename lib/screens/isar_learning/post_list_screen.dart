import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/scheme1.dart';

class PostListScreen extends StatefulWidget {
  final Isar isar;
  const PostListScreen({super.key, required this.isar});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  User? user;

  void _loadUser(int id) async {
    final res = await widget.isar.users.get(id);
    if (res != null) {
      await res.posts.load();
      setState(() => user = res);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUser(ModalRoute.of(context)!.settings.arguments as int);
  }

  void _addPost() async {
    final post = Post()..title = "Post ${user!.posts.length + 1}"..content = "Isar Content";
    await widget.isar.writeTxn(() async {
      await widget.isar.posts.put(post);
      user!.posts.add(post);
      await user!.posts.save();
    });
    _loadUser(user!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${user?.username}'s Posts")),
      body: ListView.builder(
        itemCount: user?.posts.length ?? 0,
        itemBuilder: (context, i) => ListTile(
          title: Text(user!.posts.elementAt(i).title),
          onTap: () => Navigator.pushNamed(context, '/post_detail', arguments: user!.posts.elementAt(i).id),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _addPost, child: const Icon(Icons.add)),
    );
  }
}
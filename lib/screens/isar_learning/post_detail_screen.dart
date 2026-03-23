import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/scheme1.dart';

class PostDetailScreen extends StatefulWidget {
  final Isar isar;
  const PostDetailScreen({super.key, required this.isar});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? post;

  void _loadPost(int id) async {
    final res = await widget.isar.posts.get(id);
    if (res != null) {
      await res.tags.load();
      setState(() => post = res);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadPost(ModalRoute.of(context)!.settings.arguments as int);
  }

  void _addTag() async {
    final tag = Tag()..tagName = "Tech"; 
    await widget.isar.writeTxn(() async {
      await widget.isar.tags.put(tag);
      post!.tags.add(tag);
      await post!.tags.save();
    });
    _loadPost(post!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post?.title ?? "")),
      body: Column(children: [
        Text(post?.content ?? ""),
        const Divider(),
        const Text("Tags (Many-to-Many):"),
        Wrap(children: post?.tags.map((t) => Chip(label: Text(t.tagName))).toList() ?? [])
      ]),
      floatingActionButton: FloatingActionButton(onPressed: _addTag, child: const Icon(Icons.label)),
    );
  }
}
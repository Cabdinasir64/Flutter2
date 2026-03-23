import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/scheme1.dart';

class TagExplorerScreen extends StatefulWidget {
  final Isar isar;
  const TagExplorerScreen({super.key, required this.isar});

  @override
  State<TagExplorerScreen> createState() => _TagExplorerScreenState();
}

class _TagExplorerScreenState extends State<TagExplorerScreen> {
  List<Tag> tags = [];
  bool isLoading = true;

  void _loadTags() async {
    setState(() => isLoading = true);

    final allTags = await widget.isar.tags.where().findAll();

    for (var t in allTags) {
      await t.posts.load();

      for (var p in t.posts) {
        await p.author.load();
      }
    }

    setState(() {
      tags = allTags;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tag -> Post -> User Map"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tags.length,
              itemBuilder: (context, i) {
                final tag = tags[i];
                return ExpansionTile(
                  leading: const Icon(Icons.tag, color: Colors.teal),
                  title: Text(
                    "#${tag.tagName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text("Waxaa laga helay ${tag.posts.length} Post"),
                  children: tag.posts.isEmpty
                      ? [
                          const ListTile(
                            title: Text("Tag-kan wax post ah kuma xirna"),
                          ),
                        ]
                      : tag.posts.map((post) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.article_outlined),
                              title: Text(
                                post.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "Qoraaga: ${post.author.value?.username ?? 'Lama yaqaan'}",
                              ),
                              trailing: const Icon(
                                Icons.person_pin,
                                color: Colors.blueGrey,
                              ),
                            ),
                          );
                        }).toList(),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/user3.dart';

class UserListScreen extends StatefulWidget {
  final Isar isar;
  const UserListScreen({super.key, required this.isar});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User3> users = [];
  final TextEditingController _nameController = TextEditingController();

  void _loadUsers() async {
    final results = await widget.isar.user3s.where().findAll();
    for (var user in results) {
      await user.posts.load();
    }
    setState(() => users = results);
  }

  void _addUser() async {
    if (_nameController.text.isEmpty) return;
    final newUser = User3()..name = _nameController.text;
    await widget.isar.writeTxn(() => widget.isar.user3s.put(newUser));
    _nameController.clear();
    _loadUsers();
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users (One-to-Many)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter User Name",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: _addUser,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, i) {
                final user = users[i];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text("Posts: ${user.posts.length}"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/posts',
                      arguments: user.id,
                    ).then((_) => _loadUsers());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

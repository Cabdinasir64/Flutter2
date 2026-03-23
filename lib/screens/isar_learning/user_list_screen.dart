import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/scheme1.dart';
class UserListScreen extends StatefulWidget {
  final Isar isar;
  const UserListScreen({super.key, required this.isar});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];

  void _refresh() async {
    final res = await widget.isar.users.where().findAll();
    setState(() => users = res);
  }

  @override
  void initState() { super.initState(); _refresh(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Isar Users"), actions: [
        IconButton(icon: const Icon(Icons.tag), onPressed: () => Navigator.pushNamed(context, '/tags'))
      ]),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(users[i].username),
          subtitle: const Text("Click for Profile or Posts"),
          onTap: () => _showUserActions(users[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addUser(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addUser() async {
    final newUser = User()..username = "User ${users.length + 1}";
    await widget.isar.writeTxn(() => widget.isar.users.put(newUser));
    _refresh();
  }

  void _showUserActions(User user) {
    showModalBottomSheet(context: context, builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(leading: const Icon(Icons.person), title: const Text("View Profile (1:1)"), onTap: () => Navigator.pushNamed(context, '/profile', arguments: user.id)),
        ListTile(leading: const Icon(Icons.post_add), title: const Text("View Posts (1:N)"), onTap: () => Navigator.pushNamed(context, '/posts', arguments: user.id)),
      ],
    ));
  }
}
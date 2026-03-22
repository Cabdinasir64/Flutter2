import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/user2.dart';

class User2ListPage extends StatefulWidget {
  final Isar isar;
  const User2ListPage({super.key, required this.isar});

  @override
  State<User2ListPage> createState() => _User2ListPageState();
}

class _User2ListPageState extends State<User2ListPage> {
  List<User2> users = [];

  void _loadUsers() async {
    final results = await widget.isar.user2s.where().findAll();
    setState(() => users = results);
  }

  void _addUser() async {
    final newUser = User2()
      ..name = "User ${users.length + 1}"
      ..email = "user${users.length}@example.com"
      ..phone = "061XXXXXXX"
      ..bio = "Kani waa bio-ga ardayga cusub.";

    await widget.isar.writeTxn(() => widget.isar.user2s.put(newUser));
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
      appBar: AppBar(title: const Text("User2 List")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, i) {
          final user = users[i];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: user.id);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/user1.dart';

class UserPage extends StatefulWidget {
  final Isar isar;
  const UserPage({super.key, required this.isar});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User1> userList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readUsers(); 
  }

  void _readUsers() async {
    final results = await widget.isar.user1s.where().findAll();
    setState(() => userList = results);
  }

  void _createUser() async {
    if (_controller.text.isEmpty) return;

    final newUser = User1()..name = _controller.text;
    await widget.isar.writeTxn(() => widget.isar.user1s.put(newUser));

    _controller.clear();
    _readUsers(); 
  }

  void _updateUser(User1 user) async {
    _controller.text = user.name; 

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Beddel Magaca"),
        content: TextField(controller: _controller),
        actions: [
          TextButton(
            onPressed: () async {
              user.name = _controller.text;
              await widget.isar.writeTxn(() => widget.isar.user1s.put(user));
              _controller.clear();
              Navigator.pop(context);
              _readUsers();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteUser(int id) async {
    await widget.isar.writeTxn(() => widget.isar.user1s.delete(id));
    _readUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Isar Basic CRUD")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: "Enter Name"),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: _createUser),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, i) {
                final user = userList[i];
                return ListTile(
                  title: Text(user.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () => _updateUser(user),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

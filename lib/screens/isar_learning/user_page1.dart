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

  User1? _editingUser;

  @override
  void initState() {
    super.initState();
    _readUsers();
  }

  void _readUsers() async {
    final results = await widget.isar.user1s.where().findAll();
    setState(() => userList = results);
  }

  void _saveUser() async {
    if (_controller.text.isEmpty) return;

    if (_editingUser == null) {
      final newUser = User1()..name = _controller.text;
      await widget.isar.writeTxn(() => widget.isar.user1s.put(newUser));
    } else {
      _editingUser!.name = _controller.text;
      await widget.isar.writeTxn(() => widget.isar.user1s.put(_editingUser!));

      _editingUser = null;
    }

    _controller.clear();
    _readUsers();
  }

  void _setUpdateMode(User1 user) {
    setState(() {
      _editingUser = user;
      _controller.text = user.name;
    });
  }

  void _deleteUser(int id) async {
    await widget.isar.writeTxn(() => widget.isar.user1s.delete(id));
    _readUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Isar Inline CRUD")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter Name",
                      labelText: _editingUser == null
                          ? "Add User"
                          : "Update User",
                      suffixIcon: _editingUser != null
                          ? IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  _editingUser = null;
                                  _controller.clear();
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _editingUser == null ? Icons.add : Icons.check_circle,
                    color: _editingUser == null ? Colors.blue : Colors.green,
                    size: 30,
                  ),
                  onPressed: _saveUser,
                ),
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
                        onPressed: () => _setUpdateMode(
                          user,
                        ), 
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

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/scheme1.dart';
class ProfileScreen extends StatefulWidget {
  final Isar isar;
  const ProfileScreen({super.key, required this.isar});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  final bioController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id = ModalRoute.of(context)!.settings.arguments as int;
    _loadData(id);
  }

  void _loadData(int id) async {
    final res = await widget.isar.users.get(id);
    if (res != null) {
      await res.profile.load();
      setState(() {
        user = res;
        bioController.text = user?.profile.value?.bio ?? "";
      });
    }
  }

  void _saveProfile() async {
    if (user == null) return;
    final profile = user!.profile.value ?? Profile();
    profile.bio = bioController.text;
    profile.avatarUrl = "https://avatar.com/${user!.username}";

    await widget.isar.writeTxn(() async {
      await widget.isar.profiles.put(profile);
      user!.profile.value = profile;
      await user!.profile.save();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile: ${user?.username}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: bioController, decoration: const InputDecoration(labelText: "Bio")),
          const SizedBox(height: 20),
          
          ElevatedButton(onPressed: _saveProfile, child: const Text("Save Profile (1:1 Link)"))
        ]),
      ),
    );
  }
}
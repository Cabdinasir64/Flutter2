import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter2/models/user2.dart';

class User2DetailsPage extends StatelessWidget {
  final Isar isar;
  const User2DetailsPage({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(title: const Text("User Details")),
      body: FutureBuilder<User2?>(
        future: isar.user2s.get(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('User not found $userId'));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${user.name}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text("Email: ${user.email}"),
                Text("Phone: ${user.phone}"),
                const SizedBox(height: 20),
                const Text(
                  "Bio:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(user.bio ?? "No bio available"),
                const Spacer(),
                Text("Created at: ${user.createdAt.toString()}"),
              ],
            ),
          );
        },
      ),
    );
  }
}

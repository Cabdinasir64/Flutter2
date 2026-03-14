import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class SharedPref2 extends StatelessWidget {
  SharedPref2({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Provider + Shared Prefs")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "Magaca hadda: ${userProvider.currentName}",
              style: TextStyle(fontSize: 22, color: Colors.blue),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Bedel Magaca"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                userProvider.updateName(_controller.text);
                _controller.clear();
              },
              child: Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
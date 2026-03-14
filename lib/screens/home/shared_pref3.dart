import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider2.dart';

class SharedPref2 extends StatelessWidget {
  SharedPref2({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Provider Example 2")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              color: Colors.grey[200],
              child: Column(
                children: [
                  Text(
                    "Xogta Kaydsan:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Magaca: ${userProvider.name}"),
                  Text("Da'da: ${userProvider.age}"),
                ],
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Magaca"),
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: "Da'da"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    userProvider.saveUser(
                      _nameController.text,
                      int.tryParse(_ageController.text) ?? 0,
                    );
                  },
                  child: Text("Keydi"),
                ),
                ElevatedButton(
                  onPressed: () => userProvider.deleteUser(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Tirtir", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

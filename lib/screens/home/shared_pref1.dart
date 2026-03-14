import 'package:flutter/material.dart';
import '../../services/shared_prefs.dart';

class SharedPref1 extends StatefulWidget {
  const SharedPref1({super.key});
  @override
  State<SharedPref1> createState() => _SharedPref1State();
}

class _SharedPref1State extends State<SharedPref1> {
  final TextEditingController _nameController = TextEditingController();
  String _savedName = "";

  @override
  void initState() {
    super.initState();
    _savedName = SharedPrefsService.getName();
  }

  void _handleSave() async {
    await SharedPrefsService.setName(_nameController.text);
    setState(() {
      _savedName = SharedPrefsService.getName();
    });
    _nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shared Preferences")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Gali Magacaaga"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _handleSave, child: Text("Keydi Magaca")),
            SizedBox(height: 40),
            Text(
              "Magaca Keydsan: $_savedName",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

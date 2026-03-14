import 'package:flutter/material.dart';
import '../services/shared_prefs.dart';

class UserProvider extends ChangeNotifier {
  String _currentName = SharedPrefsService.getName();

  String get currentName => _currentName;

  Future<void> updateName(String newName) async {
    await SharedPrefsService.setName(newName);
    _currentName = newName;
    notifyListeners();
  }
}

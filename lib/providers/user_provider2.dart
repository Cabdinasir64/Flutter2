import 'package:flutter/material.dart';
import '../services/shared_pref2.dart';

class UserProvider extends ChangeNotifier {
  String _name = SharedPrefsService.getName();
  int _age = SharedPrefsService.getAge();

  String get name => _name;
  int get age => _age;

  Future<void> saveUser(String name, int age) async {
    await SharedPrefsService.setUserData(name, age);
    _name = name;
    _age = age;
    notifyListeners();
  }

  Future<void> deleteUser() async {
    await SharedPrefsService.clearUser();
    _name = "Magac ma jiro";
    _age = 0;
    notifyListeners();
  }
}

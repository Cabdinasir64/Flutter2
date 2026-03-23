import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/scheme2.dart';
import 'package:flutter2/screens/isar_learning/search2.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  
  final isar = await Isar.open(
    [ProductSchema],
    directory: dir.path,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Search2Screen(isar: isar),
    },
  ));
}
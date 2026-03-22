import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/user2.dart';
import 'package:flutter2/screens/isar_learning/user2_list_page.dart';
import 'package:flutter2/screens/isar_learning/user2_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([User2Schema], directory: dir.path);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => User2ListPage(isar: isar),
      '/details': (context) => User2DetailsPage(isar: isar),
    },
  ));
}
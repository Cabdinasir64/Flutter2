import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter2/models/user3.dart';
import 'package:flutter2/models/post1.dart';
import 'package:flutter2/screens/isar_learning/user_list_screen3.dart';
import 'package:flutter2/screens/isar_learning/post_manager_screen1.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final dir = await getApplicationDocumentsDirectory();
  
  final isar = await Isar.open(
    [User3Schema, Post1Schema], 
    directory: dir.path
  );

  runApp(IsarRelationshipApp(isar: isar));
}

class IsarRelationshipApp extends StatelessWidget {
  final Isar isar;
  const IsarRelationshipApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Isar Relationships',
      initialRoute: '/',
      routes: {
        '/': (context) => UserListScreen(isar: isar),
        '/posts': (context) => PostManagerScreen(isar: isar),
      },
    );
  }
}
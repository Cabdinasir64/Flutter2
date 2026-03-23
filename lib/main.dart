import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter2/models/scheme1.dart';
import 'package:flutter2/screens/isar_learning/post_detail_screen.dart';
import 'package:flutter2/screens/isar_learning/post_list_screen.dart';
import 'package:flutter2/screens/isar_learning/profile_screen.dart';
import 'package:flutter2/screens/isar_learning/user_list_screen.dart';
import 'package:flutter2/screens/isar_learning/tag_explorer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  
  final isar = await Isar.open(
    [UserSchema, ProfileSchema, PostSchema, TagSchema],
    directory: dir.path,
  );

  runApp(IsarMasterApp(isar: isar));
}

class IsarMasterApp extends StatelessWidget {
  final Isar isar;
  const IsarMasterApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => UserListScreen(isar: isar),
        '/profile': (context) => ProfileScreen(isar: isar),
        '/posts': (context) => PostListScreen(isar: isar),
        '/post_detail': (context) => PostDetailScreen(isar: isar),
        '/tags': (context) => TagExplorerScreen(isar: isar),
      },
    );
  }
}
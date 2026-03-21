import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter2/models/user1.dart';
import 'package:flutter2/screens/isar_learning/user_page1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([User1Schema], directory: dir.path);

  runApp(IsarRouterApp(isar: isar));
}

class IsarRouterApp extends StatelessWidget {
  final Isar isar;
  const IsarRouterApp({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', 
      routes: {
        '/': (context) => UserPage(isar: isar),
      },
    );
  }
}

import 'package:isar/isar.dart';
import 'post1.dart'; 

part 'user3.g.dart';

@collection
class User3 {
  Id id = Isar.autoIncrement;
  late String name;

  final posts = IsarLinks<Post1>(); 
}
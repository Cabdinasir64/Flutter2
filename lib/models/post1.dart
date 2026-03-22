import 'package:isar/isar.dart';
import 'user3.dart'; 

part 'post1.g.dart';

@collection
class Post1 {
  Id id = Isar.autoIncrement;
  late String title;
  late String content;

  @Backlink(to: 'posts')
  final user = IsarLink<User3>(); 
}
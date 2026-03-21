import 'package:isar/isar.dart';
part 'user1.g.dart';

@collection
class User1 {
  Id id = Isar.autoIncrement;
  late String name;
}
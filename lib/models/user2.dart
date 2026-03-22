import 'package:isar/isar.dart';
part 'user2.g.dart';

@collection
class User2 {
  Id id = Isar.autoIncrement;

  late String name;
  
  late String email;
  
  late String phone;
  
  String? bio; 

  DateTime createdAt = DateTime.now(); 
}
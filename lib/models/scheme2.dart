import 'package:isar/isar.dart';

part 'scheme2.g.dart';

@collection
class Product {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value) 
  late String name;

  late String category;

  late double price;

  bool inStock = true;
}
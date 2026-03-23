import 'package:isar/isar.dart';

part 'scheme1.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  late String username;

  final profile = IsarLink<Profile>();

  final posts = IsarLinks<Post>();
}

@collection
class Profile {
  Id id = Isar.autoIncrement;
  late String bio;
  late String avatarUrl;

  @Backlink(to: 'profile')
  final user = IsarLink<User>();
}

@collection
class Post {
  Id id = Isar.autoIncrement;
  late String title;
  late String content;

  @Backlink(to: 'posts')
  final author = IsarLink<User>();

  final tags = IsarLinks<Tag>();
}

@collection
class Tag {
  Id id = Isar.autoIncrement;
  late String tagName;

  @Backlink(to: 'tags')
  final posts = IsarLinks<Post>();
}

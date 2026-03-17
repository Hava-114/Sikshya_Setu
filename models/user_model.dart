import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String username;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  int totalPoints;
  
  @HiveField(3)
  List<String> completedQuizzes;
  
  @HiveField(4)
  List<String> badges;

  User({
    required this.username,
    required this.name,
    this.totalPoints = 0,
    this.completedQuizzes = const [],
    this.badges = const [],
  });
}

@HiveType(typeId: 1)
class Badge extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String icon;
  
  @HiveField(3)
  DateTime earnedDate;

  Badge({
    required this.id,
    required this.name,
    required this.icon,
    required this.earnedDate,
  });
}
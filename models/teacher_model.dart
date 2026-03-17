import 'package:hive/hive.dart';

part 'teacher_model.g.dart';

@HiveType(typeId: 10)
class Teacher extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String username;
  
  @HiveField(2)
  String name;
  
  @HiveField(3)
  String email;
  
  @HiveField(4)
  String school;
  
  @HiveField(5)
  List<String> assignedClasses;
  
  @HiveField(6)
  DateTime createdAt;

  Teacher({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.school,
    this.assignedClasses = const [],
    required this.createdAt,
  });
}

@HiveType(typeId: 11)
class StudentProgress {
  @HiveField(0)
  String studentId;
  
  @HiveField(1)
  String studentName;
  
  @HiveField(2)
  int totalPoints;
  
  @HiveField(3)
  int completedQuizzes;
  
  @HiveField(4)
  int totalQuizzes;
  
  @HiveField(5)
  double averageScore;
  
  @HiveField(6)
  List<String> badges;
  
  @HiveField(7)
  DateTime lastActive;

  StudentProgress({
    required this.studentId,
    required this.studentName,
    required this.totalPoints,
    required this.completedQuizzes,
    required this.totalQuizzes,
    required this.averageScore,
    this.badges = const [],
    required this.lastActive,
  });
}

@HiveType(typeId: 12)
class StudyMaterial {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  String fileType; // pdf, ppt, video, image
  
  @HiveField(4)
  String filePath;
  
  @HiveField(5)
  String chapterId;
  
  @HiveField(6)
  String uploadedBy;
  
  @HiveField(7)
  DateTime uploadedAt;
  
  @HiveField(8)
  int fileSize; // in KB

  StudyMaterial({
    required this.id,
    required this.title,
    required this.description,
    required this.fileType,
    required this.filePath,
    required this.chapterId,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.fileSize,
  });
}
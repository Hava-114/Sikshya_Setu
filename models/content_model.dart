import 'package:hive/hive.dart';

part 'content_model.g.dart';

@HiveType(typeId: 5)
class ChapterContent {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String subject;
  
  @HiveField(3)
  String grade;
  
  @HiveField(4)
  String content;
  
  @HiveField(5)
  List<String> topics;
  
  @HiveField(6)
  String? imagePath;
  
  @HiveField(7)
  String? quizId;
  
  @HiveField(8)
  Duration duration; // Estimated time to complete
  
  @HiveField(9)
  DateTime lastUpdated;
  
  @HiveField(10)
  String updatedBy; // Teacher who last updated

  ChapterContent({
    required this.id,
    required this.title,
    required this.subject,
    required this.grade,
    required this.content,
    this.topics = const [],
    this.imagePath,
    this.quizId,
    this.duration = const Duration(minutes: 30),
    required this.lastUpdated,
    required this.updatedBy,
  });
}

@HiveType(typeId: 6)
class StudyMaterial {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  MaterialType type;
  
  @HiveField(4)
  String filePath;
  
  @HiveField(5)
  String chapterId;
  
  @HiveField(6)
  String uploadedBy;
  
  @HiveField(7)
  DateTime uploadedAt;
  
  @HiveField(8)
  int fileSize; // in bytes
  
  @HiveField(9)
  int downloadCount;
  
  @HiveField(10)
  List<String> tags;
  
  @HiveField(11)
  List<int>? fileBytes; // For web platform file storage

  StudyMaterial({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.filePath,
    required this.chapterId,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.fileSize,
    this.downloadCount = 0,
    this.tags = const [],
    this.fileBytes,
  });
}

@HiveType(typeId: 7)
enum MaterialType {
  @HiveField(0)
  pdf,
  
  @HiveField(1)
  ppt,
  
  @HiveField(2)
  video,
  
  @HiveField(3)
  audio,
  
  @HiveField(4)
  image,
  
  @HiveField(5)
  document,
  
  @HiveField(6)
  link,
}

@HiveType(typeId: 8)
class Announcement {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String message;
  
  @HiveField(3)
  String createdBy;
  
  @HiveField(4)
  DateTime createdAt;
  
  @HiveField(5)
  DateTime? expiresAt;
  
  @HiveField(6)
  bool isImportant;
  
  @HiveField(7)
  List<String> targetClasses;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.createdBy,
    required this.createdAt,
    this.expiresAt,
    this.isImportant = false,
    this.targetClasses = const [],
  });
}

@HiveType(typeId: 9)
class Assignment {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  String chapterId;
  
  @HiveField(4)
  String assignedBy;
  
  @HiveField(5)
  DateTime assignedDate;
  
  @HiveField(6)
  DateTime dueDate;
  
  @HiveField(7)
  int totalPoints;
  
  @HiveField(8)
  List<String> attachments; // File paths or URLs
  
  @HiveField(9)
  Map<String, String> submissions; // studentId -> submission file path
  
  @HiveField(10)
  Map<String, int> grades; // studentId -> points scored

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.chapterId,
    required this.assignedBy,
    required this.assignedDate,
    required this.dueDate,
    required this.totalPoints,
    this.attachments = const [],
    this.submissions = const {},
    this.grades = const {},
  });
}
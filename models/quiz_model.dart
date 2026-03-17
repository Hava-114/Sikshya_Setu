import 'package:hive/hive.dart';

part 'quiz_model.g.dart';

@HiveType(typeId: 2)
class Quiz extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String chapterId;
  
  @HiveField(3)
  List<Question> questions;
  
  @HiveField(4)
  int points;
  
  @HiveField(5)
  int timeLimit; // in minutes

  Quiz({
    required this.id,
    required this.title,
    required this.chapterId,
    required this.questions,
    this.points = 10,
    this.timeLimit = 10,
  });
}

@HiveType(typeId: 3)
class Question extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String question;
  
  @HiveField(2)
  List<String> options;
  
  @HiveField(3)
  int correctIndex;
  
  @HiveField(4)
  String explanation;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

@HiveType(typeId: 4)
class QuizResult extends HiveObject {
  @HiveField(0)
  String quizId;
  
  @HiveField(1)
  String userId;
  
  @HiveField(2)
  int score;
  
  @HiveField(3)
  int totalQuestions;
  
  @HiveField(4)
  DateTime completedAt;
  
  @HiveField(5)
  List<int> userAnswers;

  QuizResult({
    required this.quizId,
    required this.userId,
    required this.score,
    required this.totalQuestions,
    required this.completedAt,
    required this.userAnswers,
  });
}
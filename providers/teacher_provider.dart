import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/teacher_model.dart';
import '../models/content_model.dart' as content;
import '../models/user_model.dart';

class TeacherProvider with ChangeNotifier {
  Teacher? _currentTeacher;
  bool _isTeacherLoggedIn = false;
  List<StudentProgress> _studentProgress = [];
  List<content.StudyMaterial> _studyMaterials = [];

  // Getters
  Teacher? get currentTeacher => _currentTeacher;
  bool get isTeacherLoggedIn => _isTeacherLoggedIn;
  List<StudentProgress> get studentProgress => _studentProgress;
  List<content.StudyMaterial> get studyMaterials => _studyMaterials;

  // Teacher Authentication
  Future<void> teacherLogin(String username, String password) async {
    // For prototype: Default teacher credentials
    if (username == 'teacher' && password == 'teacher123') {
      _currentTeacher = Teacher(
        id: 't001',
        username: username,
        name: 'Mr. Sharma',
        email: 'teacher@nabhaschool.edu',
        school: 'Nabha Public School',
        assignedClasses: ['5th', '6th', '7th'],
        createdAt: DateTime.now(),
      );
      _isTeacherLoggedIn = true;
      
      // Save to Hive
      final teacherBox = Hive.box<Teacher>('teacherBox');
      await teacherBox.put('current', _currentTeacher!);
      
      // Load sample data
      await _loadSampleData();
      
      notifyListeners();
    } else {
      throw Exception('Invalid credentials');
    }
  }

  void teacherLogout() {
    _currentTeacher = null;
    _isTeacherLoggedIn = false;
    _studentProgress.clear();
    _studyMaterials.clear();
    
    // Clear from Hive
    final teacherBox = Hive.box<Teacher>('teacherBox');
    teacherBox.clear();
    
    notifyListeners();
  }

  Future<void> _loadSampleData() async {
    // Load sample student progress
    final userBox = Hive.box<User>('userBox');
    final resultBox = Hive.box('resultBox');
    
    final allUsers = userBox.values.toList();
    _studentProgress = allUsers.map((user) {
      final userResults = resultBox.values
          .where((result) => result.userId == user.username)
          .toList();
      
      final completedQuizzes = user.completedQuizzes.length;
      final totalQuizzes = 3; // Assuming 3 quizzes available
      
      double avgScore = 0;
      if (userResults.isNotEmpty) {
        final totalScore = userResults.fold<int>(0, (sum, result) => sum + (result.score as int));
        avgScore = totalScore / userResults.length;
      }
      
      return StudentProgress(
        studentId: user.username,
        studentName: user.name,
        totalPoints: user.totalPoints,
        completedQuizzes: completedQuizzes,
        totalQuizzes: totalQuizzes,
        averageScore: avgScore,
        badges: user.badges,
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      );
    }).toList();

    // Load sample study materials
    _studyMaterials = [
      content.StudyMaterial(
        id: 'mat1',
        title: 'Photosynthesis PPT',
        description: 'Detailed presentation on photosynthesis process',
        type: content.MaterialType.ppt,
        filePath: 'assets/sample/sample.ppt',
        chapterId: 'science_1',
        uploadedBy: 'Mr. Sharma',
        uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
        fileSize: 2500,
      ),
      content.StudyMaterial(
        id: 'mat2',
        title: 'Math Worksheet PDF',
        description: 'Practice problems for numbers chapter',
        type: content.MaterialType.pdf,
        filePath: 'assets/sample/worksheet.pdf',
        chapterId: 'math_1',
        uploadedBy: 'Mr. Sharma',
        uploadedAt: DateTime.now().subtract(const Duration(days: 1)),
        fileSize: 1500,
      ),
      content.StudyMaterial(
        id: 'mat3',
        title: 'Grammar Notes',
        description: 'English grammar rules and examples',
        type: content.MaterialType.pdf,
        filePath: 'assets/sample/grammar.pdf',
        chapterId: 'english_1',
        uploadedBy: 'Mr. Sharma',
        uploadedAt: DateTime.now(),
        fileSize: 800,
      ),
    ];

    notifyListeners();
  }

  // Student Progress Management
  void addStudentNote(String studentId, String note) {
    // Implementation for adding notes
    notifyListeners();
  }

  // Study Materials Management
  void addStudyMaterial(content.StudyMaterial material) {
    _studyMaterials.add(material);
    notifyListeners();
  }

  void removeStudyMaterial(String materialId) {
    _studyMaterials.removeWhere((mat) => mat.id == materialId);
    notifyListeners();
  }

  // Chapter Content Management
  void updateChapterContent(String chapterId, String newContent) {
    // Implementation for updating chapter content
    notifyListeners();
  }

  // Analytics
  Map<String, dynamic> getClassAnalytics() {
    if (_studentProgress.isEmpty) {
      return {
        'totalStudents': 0,
        'averageScore': 0,
        'completionRate': 0,
        'topPerformer': null,
      };
    }

    final totalStudents = _studentProgress.length;
    final averageScore = _studentProgress
        .map((s) => s.averageScore)
        .reduce((a, b) => a + b) / totalStudents;
    
    final completionRate = (_studentProgress
        .map((s) => s.completedQuizzes / s.totalQuizzes)
        .reduce((a, b) => a + b) / totalStudents) * 100;
    
    final topPerformer = _studentProgress.reduce(
      (a, b) => a.totalPoints > b.totalPoints ? a : b,
    );

    return {
      'totalStudents': totalStudents,
      'averageScore': averageScore.toStringAsFixed(1),
      'completionRate': completionRate.toStringAsFixed(1),
      'topPerformer': topPerformer.studentName,
      'topScore': topPerformer.totalPoints,
    };
  }
}
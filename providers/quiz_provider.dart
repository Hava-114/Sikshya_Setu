import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../models/user_model.dart';
import '../services/local_storage_service.dart';

class QuizProvider with ChangeNotifier {
  List<Quiz> _quizzes = [];
  List<QuizResult> _results = [];
  final LocalStorageService _storageService = LocalStorageService();
  User? _currentUser;

  // Getters
  List<Quiz> get quizzes => _quizzes;
  List<QuizResult> get results => _results;

  QuizProvider() {
    _loadQuizzes();
    _loadResults();
  }

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  Future<void> _loadQuizzes() async {
    // Sample quizzes - in production, load from JSON
    _quizzes = [
      Quiz(
        id: 'quiz_math_1',
        title: 'Numbers Quiz',
        chapterId: 'math_1',
        points: 20,
        questions: [
          Question(
            id: 'q1',
            question: 'What is the smallest 3-digit number?',
            options: ['100', '99', '101', '999'],
            correctIndex: 0,
            explanation: '100 is the smallest 3-digit number.',
          ),
          Question(
            id: 'q2',
            question: 'Which number comes after 999?',
            options: ['1000', '1001', '998', '990'],
            correctIndex: 0,
            explanation: '1000 comes after 999.',
          ),
          Question(
            id: 'q3',
            question: 'What is 25 + 17?',
            options: ['42', '32', '52', '35'],
            correctIndex: 0,
            explanation: '25 + 17 = 42',
          ),
        ],
      ),
      Quiz(
        id: 'quiz_science_1',
        title: 'Science Basics',
        chapterId: 'science_1',
        points: 25,
        questions: [
          Question(
            id: 'q1',
            question: 'What is photosynthesis?',
            options: [
              'Process of making food in plants',
              'Breathing process in animals',
              'Water cycle',
              'Soil formation'
            ],
            correctIndex: 0,
            explanation: 'Photosynthesis is how plants make food using sunlight.',
          ),
          Question(
            id: 'q2',
            question: 'Which organ pumps blood?',
            options: ['Heart', 'Lungs', 'Brain', 'Liver'],
            correctIndex: 0,
            explanation: 'Heart pumps blood throughout the body.',
          ),
        ],
      ),
      Quiz(
        id: 'quiz_english_1',
        title: 'English Grammar',
        chapterId: 'english_1',
        points: 15,
        questions: [
          Question(
            id: 'q1',
            question: 'Which is a noun?',
            options: ['Run', 'Beautiful', 'School', 'Quickly'],
            correctIndex: 2,
            explanation: 'School is a noun - it names a place.',
          ),
          Question(
            id: 'q2',
            question: 'What is the past tense of "go"?',
            options: ['Goed', 'Went', 'Gone', 'Going'],
            correctIndex: 1,
            explanation: 'The past tense of "go" is "went".',
          ),
        ],
      ),
    ];

    // Save quizzes to storage
    for (var quiz in _quizzes) {
      await _storageService.saveQuiz(quiz);
    }

    notifyListeners();
  }

  Future<void> _loadResults() async {
    if (_currentUser != null) {
      _results = _storageService.getUserResults(_currentUser!.username);
    }
    notifyListeners();
  }

  Quiz? getQuizById(String quizId) {
    return _quizzes.firstWhere((quiz) => quiz.id == quizId);
  }

  bool isQuizCompleted(String quizId) {
    if (_currentUser == null) return false;
    return _currentUser!.completedQuizzes.contains(quizId);
  }

  Future<void> submitQuizResult({
    required String quizId,
    required int score,
    required int totalQuestions,
    required List<int> userAnswers,
  }) async {
    if (_currentUser == null) return;

    final result = QuizResult(
      quizId: quizId,
      userId: _currentUser!.username,
      score: score,
      totalQuestions: totalQuestions,
      completedAt: DateTime.now(),
      userAnswers: userAnswers,
    );

    await _storageService.saveQuizResult(result);
    
    // Reload results
    await _loadResults();
    
    notifyListeners();
  }

  int getTotalPoints() {
    return _results.fold(0, (sum, result) => sum + (result.score * 10));
  }

  double getAverageScore() {
    if (_results.isEmpty) return 0.0;
    final total = _results.fold(0.0, (sum, result) => sum + (result.score / result.totalQuestions * 100));
    return total / _results.length;
  }
}
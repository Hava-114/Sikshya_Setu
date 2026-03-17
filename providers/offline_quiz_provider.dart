import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class Question {
  final String id;
  final String topic;
  final String text;
  final List<String> options;
  final int correctAnswer;
  final String? explanation;

  Question({
    String? id,
    required this.topic,
    required this.text,
    required this.options,
    required this.correctAnswer,
    this.explanation,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'topic': topic,
    'text': text,
    'options': options,
    'correctAnswer': correctAnswer,
    'explanation': explanation,
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json['id'],
    topic: json['topic'],
    text: json['text'],
    options: List<String>.from(json['options']),
    correctAnswer: json['correctAnswer'],
    explanation: json['explanation'],
  );
}

class QuizAttempt {
  final String id;
  final String topic;
  final List<Question> questions;
  final List<int?> selectedAnswers;
  final DateTime createdAt;
  final DateTime? completedAt;

  QuizAttempt({
    String? id,
    required this.topic,
    required this.questions,
    List<int?>? selectedAnswers,
    DateTime? createdAt,
    this.completedAt,
  })  : id = id ?? const Uuid().v4(),
        selectedAnswers = selectedAnswers ?? List<int?>.filled(questions.length, null),
        createdAt = createdAt ?? DateTime.now();

  int get score {
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctAnswer) {
        correct++;
      }
    }
    return correct;
  }

  double get percentage => (score / questions.length) * 100;

  bool get isCompleted => completedAt != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'topic': topic,
    'questions': questions.map((q) => q.toJson()).toList(),
    'selectedAnswers': selectedAnswers,
    'createdAt': createdAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
  };

  factory QuizAttempt.fromJson(Map<String, dynamic> json) => QuizAttempt(
    id: json['id'],
    topic: json['topic'],
    questions: (json['questions'] as List)
        .map((q) => Question.fromJson(q as Map<String, dynamic>))
        .toList(),
    selectedAnswers: List<int?>.from(json['selectedAnswers']),
    createdAt: DateTime.parse(json['createdAt']),
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
  );
}

class OfflineQuizProvider extends ChangeNotifier {
  final String _boxName = 'offline_quiz_history';
  late Box<String> _quizBox;
  
  QuizAttempt? _currentQuiz;
  List<QuizAttempt> _quizHistory = [];
  bool _isGenerating = false;
  String? _error;

  QuizAttempt? get currentQuiz => _currentQuiz;
  List<QuizAttempt> get quizHistory => _quizHistory;
  bool get isGenerating => _isGenerating;
  String? get error => _error;

  Future<void> initialize() async {
    try {
      _quizBox = await Hive.openBox<String>(_boxName);
      await _loadQuizHistory();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize: $e';
      notifyListeners();
    }
  }

  Future<void> generateQuiz(String topic, int questionCount) async {
    _isGenerating = true;
    _error = null;
    notifyListeners();

    try {
      // Generate questions based on topic and difficulty
      final questions = _generateQuestionsForTopic(topic, questionCount);
      
      _currentQuiz = QuizAttempt(
        topic: topic,
        questions: questions,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Error generating quiz: $e';
      notifyListeners();
    } finally {
      _isGenerating = false;
      notifyListeners();
    }
  }

  List<Question> _generateQuestionsForTopic(String topic, int count) {
    // Predefined questions bank for offline use
    final questionBank = _getQuestionBankForTopic(topic);
    
    if (questionBank.isEmpty) {
      return _generateBasicQuestions(topic, count);
    }

    // Shuffle and select random questions
    questionBank.shuffle();
    return questionBank.take(count).toList();
  }

  List<Question> _getQuestionBankForTopic(String topic) {
    final bank = <String, List<Question>>{
      'Mathematics: Algebra': [
        Question(
          topic: 'Mathematics: Algebra',
          text: 'Solve for x: 2x + 5 = 13',
          options: ['2', '4', '6', '8'],
          correctAnswer: 1,
          explanation: 'Subtract 5 from both sides: 2x = 8, then divide by 2: x = 4',
        ),
        Question(
          topic: 'Mathematics: Algebra',
          text: 'What is (a + b)²?',
          options: ['a² + b²', 'a² + 2ab + b²', 'a² - b²', 'a + b'],
          correctAnswer: 1,
          explanation: '(a + b)² = a² + 2ab + b² is the perfect square formula',
        ),
        Question(
          topic: 'Mathematics: Algebra',
          text: 'Factorize: x² - 4',
          options: ['(x-2)(x+2)', '(x-4)(x+1)', '(x-1)(x+4)', '(x-2)²'],
          correctAnswer: 0,
          explanation: 'x² - 4 = x² - 2² = (x-2)(x+2) using difference of squares',
        ),
      ],
      'Mathematics: Geometry': [
        Question(
          topic: 'Mathematics: Geometry',
          text: 'What is the sum of angles in a triangle?',
          options: ['90°', '180°', '270°', '360°'],
          correctAnswer: 1,
          explanation: 'The sum of interior angles in any triangle is 180°',
        ),
        Question(
          topic: 'Mathematics: Geometry',
          text: 'Area of circle with radius r:',
          options: ['πr', '2πr', 'πr²', '2πr²'],
          correctAnswer: 2,
          explanation: 'The area of a circle is πr² where r is the radius',
        ),
      ],
      'Physics: Mechanics': [
        Question(
          topic: 'Physics: Mechanics',
          text: 'Newton\'s second law states:',
          options: ['F = m + a', 'F = m/a', 'F = ma', 'F = m - a'],
          correctAnswer: 2,
          explanation: 'Force equals mass times acceleration (F = ma)',
        ),
        Question(
          topic: 'Physics: Mechanics',
          text: 'What is the SI unit of velocity?',
          options: ['m/s²', 'm', 's', 'm/s'],
          correctAnswer: 3,
          explanation: 'Velocity is measured in meters per second (m/s)',
        ),
      ],
      'Biology: Cell Biology': [
        Question(
          topic: 'Biology: Cell Biology',
          text: 'Which organelle is the powerhouse of the cell?',
          options: ['Nucleus', 'Mitochondria', 'Ribosome', 'Golgi'],
          correctAnswer: 1,
          explanation: 'Mitochondria produces energy (ATP) for the cell',
        ),
      ],
    };

    return bank[topic] ?? [];
  }

  List<Question> _generateBasicQuestions(String topic, int count) {
    // Fallback: generate basic questions if topic not in bank
    final questions = <Question>[];
    for (int i = 0; i < count; i++) {
      questions.add(Question(
        topic: topic,
        text: 'Sample Question ${i + 1} about $topic?',
        options: ['Option A', 'Option B', 'Option C', 'Option D'],
        correctAnswer: i % 4,
        explanation: 'This is an explanation for question ${i + 1}',
      ));
    }
    return questions;
  }

  void selectAnswer(int questionIndex, int selectedOption) {
    if (_currentQuiz == null) return;
    _currentQuiz!.selectedAnswers[questionIndex] = selectedOption;
    notifyListeners();
  }

  Future<void> submitQuiz() async {
    if (_currentQuiz == null) return;

    try {
      _currentQuiz = QuizAttempt(
        id: _currentQuiz!.id,
        topic: _currentQuiz!.topic,
        questions: _currentQuiz!.questions,
        selectedAnswers: _currentQuiz!.selectedAnswers,
        createdAt: _currentQuiz!.createdAt,
        completedAt: DateTime.now(),
      );

      // Save to history
      await _saveToHistory(_currentQuiz!);
      await _loadQuizHistory();
      notifyListeners();
    } catch (e) {
      _error = 'Error submitting quiz: $e';
      notifyListeners();
    }
  }

  Future<void> _saveToHistory(QuizAttempt attempt) async {
    try {
      final key = '${attempt.topic}_${attempt.id}';
      final json = jsonEncode(attempt.toJson());
      await _quizBox.put(key, json);
    } catch (e) {
      debugPrint('Error saving quiz: $e');
    }
  }

  Future<void> _loadQuizHistory() async {
    try {
      _quizHistory = [];
      for (var key in _quizBox.keys) {
        final jsonString = _quizBox.get(key);
        if (jsonString != null) {
          final attempt = QuizAttempt.fromJson(jsonDecode(jsonString));
          _quizHistory.add(attempt);
        }
      }
      // Sort by date descending
      _quizHistory.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      debugPrint('Error loading quiz history: $e');
      _quizHistory = [];
    }
  }

  List<QuizAttempt> getQuizzesForTopic(String topic) {
    return _quizHistory.where((q) => q.topic == topic).toList();
  }

  QuizAttempt? getLatestQuizForTopic(String topic) {
    final quizzes = getQuizzesForTopic(topic);
    return quizzes.isNotEmpty ? quizzes.first : null;
  }

  double getAverageScoreForTopic(String topic) {
    final quizzes = getQuizzesForTopic(topic).where((q) => q.isCompleted).toList();
    if (quizzes.isEmpty) return 0;
    final sum = quizzes.fold<double>(0, (sum, q) => sum + q.percentage);
    return sum / quizzes.length;
  }

  void clearCurrentQuiz() {
    _currentQuiz = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _quizBox.close();
    super.dispose();
  }
}

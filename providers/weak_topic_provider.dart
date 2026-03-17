import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'offline_quiz_provider.dart';

class WeakTopic {
  final String name;
  final double averageScore;
  final int quizzesAttempted;
  final List<String> problematicConcepts;
  final DateTime lastAttempted;

  WeakTopic({
    required this.name,
    required this.averageScore,
    required this.quizzesAttempted,
    required this.problematicConcepts,
    required this.lastAttempted,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'averageScore': averageScore,
    'quizzesAttempted': quizzesAttempted,
    'problematicConcepts': problematicConcepts,
    'lastAttempted': lastAttempted.toIso8601String(),
  };

  factory WeakTopic.fromJson(Map<String, dynamic> json) => WeakTopic(
    name: json['name'],
    averageScore: json['averageScore'],
    quizzesAttempted: json['quizzesAttempted'],
    problematicConcepts: List<String>.from(json['problematicConcepts']),
    lastAttempted: DateTime.parse(json['lastAttempted']),
  );
}

class RevisionPlan {
  final String topicName;
  final List<String> conceptsToReview;
  final List<String> suggestedResources;
  final String difficulty;
  final Duration estimatedTime;
  final int recommendedQuizzesPerDay;

  RevisionPlan({
    required this.topicName,
    required this.conceptsToReview,
    required this.suggestedResources,
    required this.difficulty,
    required this.estimatedTime,
    required this.recommendedQuizzesPerDay,
  });

  Map<String, dynamic> toJson() => {
    'topicName': topicName,
    'conceptsToReview': conceptsToReview,
    'suggestedResources': suggestedResources,
    'difficulty': difficulty,
    'estimatedTime': estimatedTime.inMinutes,
    'recommendedQuizzesPerDay': recommendedQuizzesPerDay,
  };

  factory RevisionPlan.fromJson(Map<String, dynamic> json) => RevisionPlan(
    topicName: json['topicName'],
    conceptsToReview: List<String>.from(json['conceptsToReview']),
    suggestedResources: List<String>.from(json['suggestedResources']),
    difficulty: json['difficulty'],
    estimatedTime: Duration(minutes: json['estimatedTime']),
    recommendedQuizzesPerDay: json['recommendedQuizzesPerDay'],
  );
}

class WeakTopicProvider extends ChangeNotifier {
  final String _boxName = 'weak_topics_data';
  late Box<String> _dataBox;
  
  List<WeakTopic> _weakTopics = [];
  List<RevisionPlan> _revisionPlans = [];
  String? _error;

  List<WeakTopic> get weakTopics => _weakTopics;
  List<RevisionPlan> get revisionPlans => _revisionPlans;
  String? get error => _error;

  // Weakness threshold: topics with average score below this are considered weak
  static const double weaknessThreshold = 70.0;

  Future<void> initialize() async {
    try {
      _dataBox = await Hive.openBox<String>(_boxName);
      await _loadWeakTopics();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize: $e';
      notifyListeners();
    }
  }

  void analyzeQuizResults(List<QuizAttempt> quizzes) {
    try {
      // Group by topic
      final topicMap = <String, List<QuizAttempt>>{};
      for (var quiz in quizzes) {
        if (!topicMap.containsKey(quiz.topic)) {
          topicMap[quiz.topic] = [];
        }
        topicMap[quiz.topic]!.add(quiz);
      }

      _weakTopics = [];

      // Analyze each topic
      for (var topic in topicMap.entries) {
        final completedQuizzes = topic.value.where((q) => q.isCompleted).toList();
        if (completedQuizzes.isEmpty) continue;

        final averageScore = completedQuizzes.fold<double>(
          0,
          (sum, q) => sum + q.percentage,
        ) / completedQuizzes.length;

        // Identify problematic concepts
        final problematicConcepts = _identifyProblematicConcepts(completedQuizzes);

        if (averageScore < weaknessThreshold) {
          _weakTopics.add(WeakTopic(
            name: topic.key,
            averageScore: averageScore,
            quizzesAttempted: completedQuizzes.length,
            problematicConcepts: problematicConcepts,
            lastAttempted: completedQuizzes.last.createdAt,
          ));
        }
      }

      // Sort by lowest score first
      _weakTopics.sort((a, b) => a.averageScore.compareTo(b.averageScore));

      // Generate revision plans
      _generateRevisionPlans();

      // Save to storage
      _saveWeakTopics();
      notifyListeners();
    } catch (e) {
      _error = 'Error analyzing quiz results: $e';
      notifyListeners();
    }
  }

  List<String> _identifyProblematicConcepts(List<QuizAttempt> quizzes) {
    final concepts = <String, int>{};

    for (var quiz in quizzes) {
      for (int i = 0; i < quiz.questions.length; i++) {
        if (quiz.selectedAnswers[i] != quiz.questions[i].correctAnswer) {
          final concept = quiz.questions[i].text.split('?')[0].trim();
          concepts[concept] = (concepts[concept] ?? 0) + 1;
        }
      }
    }

    // Sort by frequency and return top 5
    final sorted = concepts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(5).map((e) => e.key).toList();
  }

  void _generateRevisionPlans() {
    _revisionPlans = [];

    for (var weakTopic in _weakTopics) {
      final difficulty = weakTopic.averageScore > 50 ? 'Medium' : 'High';
      final estimatedMinutes = difficulty == 'High' ? 120 : 60;
      final recommendedQuizzes = difficulty == 'High' ? 3 : 2;

      final plan = RevisionPlan(
        topicName: weakTopic.name,
        conceptsToReview: weakTopic.problematicConcepts,
        suggestedResources: _getSuggestedResources(weakTopic.name),
        difficulty: difficulty,
        estimatedTime: Duration(minutes: estimatedMinutes),
        recommendedQuizzesPerDay: recommendedQuizzes,
      );

      _revisionPlans.add(plan);
    }

    // Sort by difficulty
    _revisionPlans.sort((a, b) {
      final diffOrder = {'High': 0, 'Medium': 1, 'Low': 2};
      return diffOrder[a.difficulty]!.compareTo(diffOrder[b.difficulty]!);
    });
  }

  List<String> _getSuggestedResources(String topic) {
    final resources = <String, List<String>>{
      'Mathematics: Algebra': [
        'Khan Academy - Algebra Basics',
        'Practice: Solving Linear Equations',
        'Khan Academy - Polynomials',
        'Practice: Factorization',
      ],
      'Mathematics: Geometry': [
        'Khan Academy - Geometry',
        'Practice: Area and Perimeter',
        'Khan Academy - 3D Geometry',
        'Practice: Angle Properties',
      ],
      'Physics: Mechanics': [
        'Khan Academy - Mechanics',
        'Practice: Newton\'s Laws',
        'Khan Academy - Motion',
        'Practice: Force and Energy',
      ],
      'Chemistry: Organic Chemistry': [
        'Khan Academy - Organic Chemistry',
        'Practice: Bonding and Structure',
        'Khan Academy - Reactions',
        'Practice: Mechanisms',
      ],
      'Biology: Cell Biology': [
        'Khan Academy - Cell Biology',
        'Practice: Cell Structure',
        'Khan Academy - Cellular Processes',
        'Practice: Photosynthesis and Respiration',
      ],
    };

    return resources[topic] ?? [
      'Topic-specific tutorials',
      'Concept review materials',
      'Additional practice problems',
    ];
  }

  Future<void> _saveWeakTopics() async {
    try {
      await _dataBox.put('weakTopics', jsonEncode(
        _weakTopics.map((t) => t.toJson()).toList(),
      ));
      await _dataBox.put('revisionPlans', jsonEncode(
        _revisionPlans.map((p) => p.toJson()).toList(),
      ));
    } catch (e) {
      debugPrint('Error saving weak topics: $e');
    }
  }

  Future<void> _loadWeakTopics() async {
    try {
      final weakJson = _dataBox.get('weakTopics');
      if (weakJson != null) {
        final list = jsonDecode(weakJson) as List;
        _weakTopics = list
            .map((t) => WeakTopic.fromJson(t as Map<String, dynamic>))
            .toList();
      }

      final planJson = _dataBox.get('revisionPlans');
      if (planJson != null) {
        final list = jsonDecode(planJson) as List;
        _revisionPlans = list
            .map((p) => RevisionPlan.fromJson(p as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading weak topics: $e');
    }
  }

  int getOverallWeakTopicsCount() => _weakTopics.length;

  double getAverageWeakTopicScore() {
    if (_weakTopics.isEmpty) return 0;
    final sum = _weakTopics.fold<double>(0, (sum, t) => sum + t.averageScore);
    return sum / _weakTopics.length;
  }

  // Get recommended next action
  String getNextAction() {
    if (_weakTopics.isEmpty) {
      return 'Keep up the great work! No weak topics identified.';
    }
    
    final worst = _weakTopics.first;
    return 'Focus on ${worst.name} (Average: ${worst.averageScore.toStringAsFixed(1)}%). Start with: ${worst.problematicConcepts.first}';
  }

  // Mark topic as reviewed
  void markTopicReviewed(String topicName) {
    _weakTopics.removeWhere((t) => t.name == topicName);
    _revisionPlans.removeWhere((p) => p.topicName == topicName);
    _saveWeakTopics();
    notifyListeners();
  }

  @override
  void dispose() {
    _dataBox.close();
    super.dispose();
  }
}

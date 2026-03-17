import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/offline_quiz_provider.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/connectivity_indicator.dart';

class OfflineQuizPracticeScreen extends StatefulWidget {
  const OfflineQuizPracticeScreen({Key? key}) : super(key: key);

  @override
  State<OfflineQuizPracticeScreen> createState() =>
      _OfflineQuizPracticeScreenState();
}

class _OfflineQuizPracticeScreenState extends State<OfflineQuizPracticeScreen> {
  late OfflineQuizProvider _quizProvider;
  String? _selectedTopic;
  int? _selectedQuestionCount;
  int _currentQuestionIndex = 0;
  bool _showResults = false;

  // Popular topics for quick practice
  final List<String> quickTopics = [
    'Mathematics: Algebra',
    'Mathematics: Geometry',
    'Physics: Mechanics',
    'Chemistry: Organic Chemistry',
    'Biology: Cell Biology',
    'General Knowledge',
  ];

  @override
  void initState() {
    super.initState();
    _quizProvider = Provider.of<OfflineQuizProvider>(context, listen: false);
    _quizProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OfflineQuizProvider, ConnectivityProvider>(
      builder: (context, quizProvider, connectivityProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Practice Quiz'),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ConnectivityIndicator(showLabel: true),
              ),
            ],
          ),
          body: quizProvider.currentQuiz == null
              ? (_selectedTopic != null && _selectedQuestionCount == null
                  ? _buildDifficultySelection(quizProvider)
                  : _buildQuizSelection(quizProvider))
              : (_showResults
                  ? _buildResults(quizProvider)
                  : _buildQuizInterface(quizProvider)),
        );
      },
    );
  }

  Widget _buildQuizSelection(OfflineQuizProvider quizProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats card
            if (quizProvider.quizHistory.isNotEmpty)
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Quizzes',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            quizProvider.quizHistory.length.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Avg Score',
                              style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(
                            '${(quizProvider.quizHistory.isEmpty ? 0 : quizProvider.quizHistory.fold<double>(0, (sum, q) => sum + q.percentage) / quizProvider.quizHistory.length).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            const Text(
              'Select a Topic',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quickTopics.length,
              itemBuilder: (context, index) {
                final topic = quickTopics[index];
                final topicQuizzes = quizProvider.getQuizzesForTopic(topic);
                final avgScore = quizProvider.getAverageScoreForTopic(topic);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(topic),
                    subtitle: topicQuizzes.isEmpty
                        ? const Text('No quizzes yet')
                        : Text('${topicQuizzes.length} quizzes • Avg: ${avgScore.toStringAsFixed(1)}%'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      setState(() {
                        _selectedTopic = topic;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySelection(OfflineQuizProvider quizProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedTopic = null;
                    });
                  },
                ),
                Text(
                  _selectedTopic!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Quiz Difficulty & Length',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDifficultyCard(5, 'Easy', 'Quick warm-up', Colors.green),
            const SizedBox(height: 12),
            _buildDifficultyCard(10, 'Medium', 'Standard practice', Colors.orange),
            const SizedBox(height: 12),
            _buildDifficultyCard(20, 'Hard', 'Comprehensive', Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyCard(
    int questionCount,
    String difficulty,
    String description,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.local_fire_department, color: color),
        title: Text('$difficulty ($questionCount Questions)'),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          setState(() {
            _selectedQuestionCount = questionCount;
          });
          _startQuiz();
        },
      ),
    );
  }

  void _startQuiz() {
    if (_selectedTopic == null || _selectedQuestionCount == null) return;

    final quizProvider = Provider.of<OfflineQuizProvider>(context, listen: false);
    quizProvider.generateQuiz(_selectedTopic!, _selectedQuestionCount!);
    setState(() {
      _currentQuestionIndex = 0;
      _showResults = false;
    });
  }

  Widget _buildQuizInterface(OfflineQuizProvider quizProvider) {
    final quiz = quizProvider.currentQuiz!;
    final question = quiz.questions[_currentQuestionIndex];
    final selectedAnswer = quiz.selectedAnswers[_currentQuestionIndex];

    return Column(
      children: [
        // Progress bar
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / quiz.questions.length,
          minHeight: 4,
        ),
        // Question counter
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${quiz.questions.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _getDifficultyLevel(quiz.questions.length),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        // Question
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.text,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // Options
                ...List.generate(
                  question.options.length,
                  (index) => _buildOptionButton(
                    option: question.options[index],
                    index: index,
                    isSelected: selectedAnswer == index,
                    onTap: () {
                      quizProvider.selectAnswer(_currentQuestionIndex, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Navigation buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _currentQuestionIndex > 0
                      ? () {
                          setState(() {
                            _currentQuestionIndex--;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _currentQuestionIndex < quiz.questions.length - 1
                      ? () {
                          setState(() {
                            _currentQuestionIndex++;
                          });
                        }
                      : () {
                          quizProvider.submitQuiz();
                          setState(() {
                            _showResults = true;
                          });
                        },
                  icon: Icon(_currentQuestionIndex < quiz.questions.length - 1
                      ? Icons.arrow_forward
                      : Icons.check),
                  label: Text(_currentQuestionIndex < quiz.questions.length - 1
                      ? 'Next'
                      : 'Submit'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton({
    required String option,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? Colors.blue.shade50 : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                    ),
                    color: isSelected ? Colors.blue : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(OfflineQuizProvider quizProvider) {
    final quiz = quizProvider.currentQuiz!;
    final percentage = quiz.percentage;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Score circle
            SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentage >= 70 ? Colors.green : Colors.orange,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${quiz.score}/${quiz.questions.length}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Performance message
            Card(
              color: percentage >= 70 ? Colors.green.shade50 : Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      percentage >= 70
                          ? '🎉 Excellent!'
                          : percentage >= 50
                              ? '👍 Good Effort!'
                              : '💪 Keep Learning!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      percentage >= 70
                          ? 'You have mastered this topic!'
                          : percentage >= 50
                              ? 'You\'re on the right track. Review weak areas.'
                              : 'Practice more to improve your score.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Detailed results
            const Text(
              'Answer Review',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: quiz.questions.length,
              itemBuilder: (context, index) {
                final question = quiz.questions[index];
                final selectedIdx = quiz.selectedAnswers[index];
                final isCorrect = selectedIdx == question.correctAnswer;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                question.text,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your answer: ${question.options[selectedIdx ?? -1]}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (!isCorrect) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Correct answer: ${question.options[question.correctAnswer]}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        if (question.explanation != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              question.explanation!,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      quizProvider.clearCurrentQuiz();
                      setState(() {
                        _selectedTopic = null;
                        _selectedQuestionCount = null;
                        _showResults = false;
                        _currentQuestionIndex = 0;
                      });
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to Home'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      quizProvider.clearCurrentQuiz();
                      setState(() {
                        _selectedTopic = null;
                        _selectedQuestionCount = null;
                        _showResults = false;
                        _currentQuestionIndex = 0;
                      });
                      _startQuiz();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyLevel(int totalQuestions) {
    if (totalQuestions <= 5) return 'Easy';
    if (totalQuestions <= 10) return 'Medium';
    return 'Hard';
  }

}

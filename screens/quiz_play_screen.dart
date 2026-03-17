import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../models/quiz_model.dart';
import '../providers/app_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/gamification_provider.dart';

class QuizPlayScreen extends StatefulWidget {
  final String quizId;

  const QuizPlayScreen({super.key, required this.quizId});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late Quiz? quiz;
  int currentQuestionIndex = 0;
  List<int?> userAnswers = [];
  bool isQuizCompleted = false;
  int score = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    quiz = quizProvider.getQuizById(widget.quizId);
    userAnswers = List.filled(quiz?.questions.length ?? 0, null);
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _selectAnswer(int optionIndex) {
    if (isQuizCompleted) return;

    setState(() {
      userAnswers[currentQuestionIndex] = optionIndex;
    });

    // Move to next question after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (currentQuestionIndex < (quiz?.questions.length ?? 0) - 1) {
        setState(() {
          currentQuestionIndex++;
        });
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() {
    if (quiz == null) return;

    int calculatedScore = 0;
    for (int i = 0; i < quiz!.questions.length; i++) {
      if (userAnswers[i] == quiz!.questions[i].correctIndex) {
        calculatedScore++;
      }
    }

    setState(() {
      score = calculatedScore;
      isQuizCompleted = true;
    });

    // Update providers
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final gamificationProvider = Provider.of<GamificationProvider>(context, listen: false);

    // Calculate points (10 points per correct answer)
    final pointsEarned = calculatedScore * 10;
    final scorePercentage = (calculatedScore / quiz!.questions.length * 100).toInt();

    // Update user points
    appProvider.updateUserPoints(pointsEarned);
    appProvider.addCompletedQuiz(widget.quizId);

    // Update gamification
    gamificationProvider.completeQuiz(scorePercentage, quiz!.questions.length);

    // Save quiz result
    quizProvider.submitQuizResult(
      quizId: widget.quizId,
      score: calculatedScore,
      totalQuestions: quiz!.questions.length,
      userAnswers: userAnswers.map((a) => a ?? -1).toList(),
    );

    // Award badges
    if (calculatedScore == quiz!.questions.length) {
      appProvider.addBadge('perfect_score', 'Perfect Score!');
      _confettiController.play();
    }
    if (calculatedScore >= (quiz!.questions.length * 0.8)) {
      appProvider.addBadge('fast_learner', 'Fast Learner');
    }
  }

  void _restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      userAnswers = List.filled(quiz?.questions.length ?? 0, null);
      score = 0;
      isQuizCompleted = false;
    });
  }

  Widget _buildQuestionCard() {
    if (quiz == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final question = quiz!.questions[currentQuestionIndex];
    final isAnswered = userAnswers[currentQuestionIndex] != null;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question number and progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1}/${quiz!.questions.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${quiz!.points} points',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Question text
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            
            // Options
            Column(
              children: List.generate(question.options.length, (index) {
                final isSelected = userAnswers[currentQuestionIndex] == index;
                final isCorrect = index == question.correctIndex;
                bool showCorrectAnswer = false;
                
                if (isQuizCompleted && isAnswered) {
                  showCorrectAnswer = true;
                }
                
                Color getOptionColor() {
                  if (!showCorrectAnswer) {
                    return isSelected ? Colors.blue : Colors.grey[200]!;
                  }
                  if (isCorrect) {
                    return Colors.green;
                  }
                  if (isSelected && !isCorrect) {
                    return Colors.red;
                  }
                  return Colors.grey[200]!;
                }
                
                Color getTextColor() {
                  if (!showCorrectAnswer) {
                    return isSelected ? Colors.white : Colors.black;
                  }
                  if (isCorrect || (isSelected && !isCorrect)) {
                    return Colors.white;
                  }
                  return Colors.black;
                }
                
                return GestureDetector(
                  onTap: () => _selectAnswer(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: getOptionColor(),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              color: getTextColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question.options[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: getTextColor(),
                            ),
                          ),
                        ),
                        if (showCorrectAnswer && isCorrect)
                          const Icon(Icons.check_circle, color: Colors.white),
                        if (showCorrectAnswer && isSelected && !isCorrect)
                          const Icon(Icons.cancel, color: Colors.white),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Confetti
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
            
            // Trophy icon
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amber[50],
              child: Icon(
                score == (quiz?.questions.length ?? 0)
                    ? Icons.emoji_events
                    : Icons.check_circle,
                size: 60,
                color: score == (quiz?.questions.length ?? 0)
                    ? Colors.amber
                    : Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            
            // Score text
            Text(
              score == (quiz?.questions.length ?? 0)
                  ? 'Perfect Score! 🎉'
                  : 'Quiz Completed!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Score details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '$score/${quiz?.questions.length ?? 0}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Correct Answers',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Points Earned: ${score * 10}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Percentage
            Text(
              '${((score / (quiz?.questions.length ?? 1)) * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getPercentageColor(score / (quiz?.questions.length ?? 1)),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: score / (quiz?.questions.length ?? 1),
              backgroundColor: Colors.grey[200],
              color: _getPercentageColor(score / (quiz?.questions.length ?? 1)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Back to Quizzes'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _restartQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Try Again'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz?.title ?? 'Quiz'),
        backgroundColor: const Color(0xFF4A90E2),
        actions: [
          if (!isQuizCompleted)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${currentQuestionIndex + 1}/${quiz?.questions.length ?? 0}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress indicator
            if (!isQuizCompleted)
              LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / (quiz?.questions.length ?? 1),
                backgroundColor: Colors.grey[200],
                color: Colors.blue,
                minHeight: 4,
              ),
            const SizedBox(height: 16),
            
            // Main content
            Expanded(
              child: isQuizCompleted ? _buildResultsCard() : _buildQuestionCard(),
            ),
            
            // Navigation buttons
            if (!isQuizCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: currentQuestionIndex > 0
                            ? () {
                                setState(() {
                                  currentQuestionIndex--;
                                });
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back),
                            SizedBox(width: 8),
                            Text('Previous'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: userAnswers[currentQuestionIndex] != null
                            ? () {
                                if (currentQuestionIndex < (quiz?.questions.length ?? 0) - 1) {
                                  setState(() {
                                    currentQuestionIndex++;
                                  });
                                } else {
                                  _finishQuiz();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentQuestionIndex < (quiz?.questions.length ?? 0) - 1
                                  ? 'Next'
                                  : 'Finish',
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
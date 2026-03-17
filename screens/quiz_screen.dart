import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/student_status_bar.dart';
import '../providers/quiz_provider.dart';
import 'quiz_play_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final quizzes = quizProvider.quizzes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QUIZ'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          const StudentStatusBar(compact: false),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Quizzes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Test your knowledge and earn points!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];
                        final isCompleted = quizProvider.isQuizCompleted(quiz.id);
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isCompleted 
                                  ? Colors.green 
                                  : const Color(0xFF4A90E2),
                              child: Icon(
                                isCompleted ? Icons.check : Icons.quiz,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(quiz.title),
                            subtitle: Text(
                              '${quiz.questions.length} questions • ${quiz.points} points',
                            ),
                            trailing: Chip(
                              label: Text(
                                isCompleted ? 'Completed' : 'Start',
                                style: TextStyle(
                                  color: isCompleted ? Colors.white : Colors.blue,
                                ),
                              ),
                              backgroundColor: isCompleted 
                                  ? Colors.green 
                                  : Colors.blue[50],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizPlayScreen(quizId: quiz.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
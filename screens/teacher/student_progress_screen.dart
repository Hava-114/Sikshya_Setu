import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/teacher_provider.dart';

class StudentProgressScreen extends StatefulWidget {
  const StudentProgressScreen({super.key});

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final progressList = Provider.of<TeacherProvider>(context).studentProgress;
    
    // Filter based on selection
    List filteredList = progressList;
    if (_filter == 'top') {
      filteredList = List.from(progressList)
        ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    } else if (_filter == 'low') {
      filteredList = List.from(progressList)
        ..sort((a, b) => a.totalPoints.compareTo(b.totalPoints));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Progress'),
        backgroundColor: const Color(0xFF2C3E50),
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All Students', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Top Performers', 'top'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Need Attention', 'low'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Recently Active', 'recent'),
                ],
              ),
            ),
          ),
          
          // Progress list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final progress = filteredList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              child: const Icon(Icons.person, color: Colors.blue),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    progress.studentName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${progress.studentId}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text('${progress.totalPoints} pts'),
                              backgroundColor: Colors.blue[50],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Progress metrics
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMetric(
                              'Quizzes Completed',
                              '${progress.completedQuizzes}/${progress.totalQuizzes}',
                              Icons.quiz,
                            ),
                            _buildMetric(
                              'Avg Score',
                              '${progress.averageScore.toStringAsFixed(1)}%',
                              Icons.score,
                            ),
                            _buildMetric(
                              'Badges',
                              '${progress.badges.length}',
                              Icons.emoji_events,
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Progress bar
                        LinearProgressIndicator(
                          value: progress.completedQuizzes / progress.totalQuizzes,
                          backgroundColor: Colors.grey[200],
                          color: _getProgressColor(progress.completedQuizzes / progress.totalQuizzes),
                          minHeight: 6,
                        ),
                        
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress: ${((progress.completedQuizzes / progress.totalQuizzes) * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'Last active: ${_formatDate(progress.lastActive)}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        
                        // Action buttons
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _showStudentDetails(progress);
                                },
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('View Details'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _sendMessage(progress.studentId);
                                },
                                icon: const Icon(Icons.message, size: 16),
                                label: const Text('Message'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: _filter == value,
      onSelected: (selected) {
        setState(() => _filter = selected ? value : 'all');
      },
      selectedColor: Colors.blue[100],
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }

  void _showStudentDetails(progress) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${progress.studentName} - Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Student ID', progress.studentId),
                _buildDetailRow('Total Points', '${progress.totalPoints}'),
                _buildDetailRow('Average Score', '${progress.averageScore.toStringAsFixed(1)}%'),
                _buildDetailRow('Completion Rate', '${((progress.completedQuizzes / progress.totalQuizzes) * 100).toStringAsFixed(0)}%'),
                _buildDetailRow('Badges Earned', '${progress.badges.length}'),
                
                if (progress.badges.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text('Badges:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: progress.badges.map((badge) {
                          return Chip(
                            label: Text(badge),
                            backgroundColor: Colors.amber[50],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _sendMessage(String studentId) {
    showDialog(
      context: context,
      builder: (context) {
        final messageController = TextEditingController();
        return AlertDialog(
          title: const Text('Send Message'),
          content: TextField(
            controller: messageController,
            decoration: const InputDecoration(
              hintText: 'Type your message here...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement message sending
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message sent!')),
                );
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weak_topic_provider.dart';
import '../providers/offline_quiz_provider.dart';
import '../widgets/connectivity_indicator.dart';

class WeakTopicsDashboard extends StatefulWidget {
  const WeakTopicsDashboard({Key? key}) : super(key: key);

  @override
  State<WeakTopicsDashboard> createState() => _WeakTopicsDashboardState();
}

class _WeakTopicsDashboardState extends State<WeakTopicsDashboard> {
  @override
  void initState() {
    super.initState();
    _analyzeQuizzes();
  }

  void _analyzeQuizzes() {
    final quizProvider = Provider.of<OfflineQuizProvider>(context, listen: false);
    final weakProvider = Provider.of<WeakTopicProvider>(context, listen: false);
    weakProvider.analyzeQuizResults(quizProvider.quizHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeakTopicProvider, OfflineQuizProvider>(
      builder: (context, weakProvider, quizProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Learning Analytics'),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ConnectivityIndicator(showLabel: false),
              ),
            ],
          ),
          body: weakProvider.weakTopics.isEmpty && quizProvider.quizHistory.isEmpty
              ? _buildEmptyState()
              : _buildContent(weakProvider, quizProvider),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Quiz Data Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete some quizzes to see your analytics',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.quiz),
            label: const Text('Take a Quiz'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(WeakTopicProvider weakProvider, OfflineQuizProvider quizProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall stats
            _buildStatsSection(weakProvider, quizProvider),
            const SizedBox(height: 24),
            // Next action
            if (weakProvider.weakTopics.isNotEmpty)
              _buildNextActionCard(weakProvider),
            const SizedBox(height: 24),
            // Weak topics
            if (weakProvider.weakTopics.isNotEmpty) ...[
              const Text(
                'Topics Needing Improvement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weakProvider.weakTopics.length,
                itemBuilder: (context, index) {
                  final weakTopic = weakProvider.weakTopics[index];
                  return _buildWeakTopicCard(weakTopic, weakProvider);
                },
              ),
              const SizedBox(height: 24),
            ],
            // Revision plans
            if (weakProvider.revisionPlans.isNotEmpty) ...[
              const Text(
                'Recommended Revision Plans',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weakProvider.revisionPlans.length,
                itemBuilder: (context, index) {
                  final plan = weakProvider.revisionPlans[index];
                  return _buildRevisionPlanCard(plan);
                },
              ),
            ],
            // Topic-wise performance
            const SizedBox(height: 24),
            const Text(
              'Topic Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._buildTopicPerformanceList(quizProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(WeakTopicProvider weakProvider, OfflineQuizProvider quizProvider) {
    final totalQuizzes = quizProvider.quizHistory.length;
    final avgScore = totalQuizzes == 0
        ? 0.0
        : quizProvider.quizHistory.fold<double>(0, (sum, q) => sum + q.percentage) /
            totalQuizzes;
    final weakCount = weakProvider.weakTopics.length;

    return Row(
      children: [
        _buildStatCard('Total Quizzes', totalQuizzes.toString(), Colors.blue),
        const SizedBox(width: 12),
        _buildStatCard(
          'Avg Score',
          '${avgScore.toStringAsFixed(1)}%',
          avgScore >= 70 ? Colors.green : Colors.orange,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'Weak Topics',
          weakCount.toString(),
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextActionCard(WeakTopicProvider weakProvider) {
    final nextAction = weakProvider.getNextAction();
    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                const Text(
                  'Recommended Next Step',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              nextAction,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeakTopicCard(WeakTopic topic, WeakTopicProvider weakProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    topic.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${topic.averageScore.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: topic.averageScore / 100,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                topic.averageScore >= 70 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${topic.quizzesAttempted} quizzes attempted',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Problematic concepts:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: topic.problematicConcepts.map((concept) {
                return Chip(
                  label: Text(
                    concept.length > 30 ? '${concept.substring(0, 30)}...' : concept,
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: Colors.red.shade50,
                  side: BorderSide(color: Colors.red.shade200),
                  padding: EdgeInsets.zero,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  weakProvider.markTopicReviewed(topic.name);
                },
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Mark as Reviewed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade50,
                  foregroundColor: Colors.green.shade700,
                  side: BorderSide(color: Colors.green.shade300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevisionPlanCard(RevisionPlan plan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    plan.topicName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(plan.difficulty).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    plan.difficulty,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getDifficultyColor(plan.difficulty),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${plan.estimatedTime.inMinutes} mins',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.quiz, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${plan.recommendedQuizzesPerDay} quizzes/day',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Focus on:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              children: plan.conceptsToReview.map((concept) {
                return Chip(
                  label: Text(
                    concept.length > 25 ? '${concept.substring(0, 25)}...' : concept,
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue.shade300),
                  padding: EdgeInsets.zero,
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            const Text(
              'Resources:',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            ...plan.suggestedResources.take(2).map((resource) {
              return Row(
                children: [
                  Icon(Icons.link, size: 14, color: Colors.blue.shade700),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      resource,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTopicPerformanceList(OfflineQuizProvider quizProvider) {
    final topicStats = <String, double>{};
    
    for (var quiz in quizProvider.quizHistory) {
      if (topicStats.containsKey(quiz.topic)) {
        topicStats[quiz.topic] = topicStats[quiz.topic]! + quiz.percentage;
      } else {
        topicStats[quiz.topic] = quiz.percentage;
      }
    }

    final topicCounts = <String, int>{};
    for (var quiz in quizProvider.quizHistory) {
      topicCounts[quiz.topic] = (topicCounts[quiz.topic] ?? 0) + 1;
    }

    for (var topic in topicStats.keys) {
      topicStats[topic] = topicStats[topic]! / topicCounts[topic]!;
    }

    final sorted = topicStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.map((entry) {
      final score = entry.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                entry.key,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Container(
              width: 50,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: score >= 70
                    ? Colors.green.shade50
                    : score >= 50
                        ? Colors.orange.shade50
                        : Colors.red.shade50,
              ),
              alignment: Alignment.center,
              child: Text(
                '${score.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: score >= 70
                      ? Colors.green
                      : score >= 50
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}

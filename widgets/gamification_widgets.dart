import 'package:flutter/material.dart';
import '../models/gamification_model.dart';

class PlayerLevelCard extends StatelessWidget {
  final PlayerLevel playerLevel;
  final VoidCallback? onTap;

  const PlayerLevelCard({
    super.key,
    required this.playerLevel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getRankColor(playerLevel.rank).withOpacity(0.8),
                _getRankColor(playerLevel.rank).withOpacity(0.3),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: _getRankColor(playerLevel.rank).withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${playerLevel.level}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _getRankColor(playerLevel.rank),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playerLevel.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            playerLevel.rank,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Experience',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${playerLevel.totalExperience}/${playerLevel.experienceForNextLevel}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: playerLevel.experienceProgress / 100,
                      minHeight: 6,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRankColor(String rank) {
    switch (rank) {
      case 'Diamond':
        return const Color(0xFF00D4FF);
      case 'Platinum':
        return const Color(0xFFE5E5E5);
      case 'Gold':
        return const Color(0xFFFFD700);
      case 'Silver':
        return const Color(0xFFC0C0C0);
      default:
        return const Color(0xFFCD7F32);
    }
  }
}

class BadgeWidget extends StatelessWidget {
  final GameBadge badge;
  final bool isLocked;

  const BadgeWidget({
    super.key,
    required this.badge,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: badge.name,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLocked ? Colors.grey[300] : Colors.amber[50],
          border: Border.all(
            color: isLocked ? Colors.grey[400]! : Colors.amber[700]!,
            width: 2,
          ),
          boxShadow: !isLocked
              ? [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                badge.icon,
                style: TextStyle(
                  fontSize: 28,
                  color: isLocked ? Colors.grey : null,
                ),
              ),
              if (isLocked)
                const Icon(
                  Icons.lock,
                  size: 16,
                  color: Colors.grey,
                )
            ],
          ),
        ),
      ),
    );
  }
}

class StreakWidget extends StatelessWidget {
  final StudyStreak streak;

  const StreakWidget({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red[50],
                  ),
                  child: Icon(
                    Icons.local_fire_department,
                    color: Colors.red[400],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Streak',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      '${streak.currentStreak} day${streak.currentStreak != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    border: Border.all(color: Colors.amber[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${streak.streakBonus}x',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Best: ${streak.longestStreak} days',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        'Total: ${streak.totalStudyDays} days',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (streak.isStreakAlive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(color: Colors.green[400]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Active ✓',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: achievement.isUnlocked ? Colors.white : Colors.grey[50],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: achievement.isUnlocked ? Colors.amber[50] : Colors.grey[200],
                border: Border.all(
                  color: achievement.isUnlocked ? Colors.amber[400]! : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  _getIcon(achievement.id),
                  style: TextStyle(
                    fontSize: 28,
                    color: achievement.isUnlocked ? null : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: achievement.isUnlocked
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      if (achievement.isUnlocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green[400]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '+${achievement.pointsReward}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: achievement.progressPercentage / 100,
                      minHeight: 4,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        achievement.isUnlocked
                            ? Colors.green[400]!
                            : Colors.blue[400]!,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${achievement.currentProgress.toInt()}/${achievement.targetProgress}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
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

  String _getIcon(String achievementId) {
    const iconMap = {
      'first_quiz': '🎯',
      'perfect_score_1': '⭐',
      'complete_5_quizzes': '📚',
      'complete_10_quizzes': '🏆',
      'complete_25_quizzes': '👑',
      'streak_3_days': '🔥',
      'streak_7_days': '💎',
      'level_5': '🌟',
      'level_10': '✨',
    };
    return iconMap[achievementId] ?? '🎖️';
  }
}

class DailyQuestCard extends StatelessWidget {
  final DailyQuest quest;
  final VoidCallback onTap;

  const DailyQuestCard({
    super.key,
    required this.quest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: quest.isCompleted ? Colors.green[50] : Colors.white,
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: quest.isCompleted ? Colors.green[100] : Colors.blue[50],
                ),
                child: Center(
                  child: Icon(
                    quest.isCompleted ? Icons.check_circle : Icons.task_alt,
                    color: quest.isCompleted ? Colors.green : Colors.blue,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quest.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!quest.isCompleted)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: quest.progress / 100,
                          minHeight: 4,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue[400]!,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      border: Border.all(color: Colors.amber[400]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+${quest.reward}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.amber[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (!quest.isCompleted)
                    Text(
                      '${quest.currentCount}/${quest.targetCount}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

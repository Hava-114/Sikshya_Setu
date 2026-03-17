import 'package:hive/hive.dart';

part 'gamification_model.g.dart';

// Badge types
@HiveType(typeId: 14)
class GameBadge extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  String icon; // emoji or icon name
  
  @HiveField(4)
  DateTime earnedDate;
  
  @HiveField(5)
  String badgeType; // 'achievement', 'streak', 'milestone'

  GameBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.earnedDate,
    required this.badgeType,
  });
}

// Achievement system
@HiveType(typeId: 15)
class Achievement extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  int pointsReward;
  
  @HiveField(4)
  String requirement; // e.g., 'complete_5_quizzes'
  
  @HiveField(5)
  int currentProgress;
  
  @HiveField(6)
  int targetProgress;
  
  @HiveField(7)
  bool isUnlocked;
  
  @HiveField(8)
  DateTime? unlockedDate;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsReward,
    required this.requirement,
    required this.currentProgress,
    required this.targetProgress,
    this.isUnlocked = false,
    this.unlockedDate,
  });

  double get progressPercentage => (currentProgress / targetProgress * 100).clamp(0, 100);
}

// Streak tracking
@HiveType(typeId: 16)
class StudyStreak extends HiveObject {
  @HiveField(0)
  int currentStreak; // consecutive days
  
  @HiveField(1)
  int longestStreak;
  
  @HiveField(2)
  DateTime lastStudyDate;
  
  @HiveField(3)
  int totalStudyDays;
  
  @HiveField(4)
  int streakBonus; // bonus points multiplier

  StudyStreak({
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.lastStudyDate,
    this.totalStudyDays = 0,
    this.streakBonus = 1,
  });

  bool get isStreakAlive {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return lastStudyDate.year == yesterday.year &&
        lastStudyDate.month == yesterday.month &&
        lastStudyDate.day == yesterday.day;
  }
}

// Player level system
@HiveType(typeId: 17)
class PlayerLevel extends HiveObject {
  @HiveField(0)
  int level;
  
  @HiveField(1)
  int totalExperience;
  
  @HiveField(2)
  int experienceForNextLevel;
  
  @HiveField(3)
  String title; // e.g., 'Novice Learner', 'Knowledge Seeker'
  
  @HiveField(4)
  String rank; // e.g., 'Bronze', 'Silver', 'Gold', 'Platinum', 'Diamond'

  PlayerLevel({
    this.level = 1,
    this.totalExperience = 0,
    this.experienceForNextLevel = 100,
    this.title = 'Novice Learner',
    this.rank = 'Bronze',
  });

  double get experienceProgress => (totalExperience / experienceForNextLevel * 100).clamp(0, 100);

  void addExperience(int xp) {
    totalExperience += xp;
    while (totalExperience >= experienceForNextLevel) {
      totalExperience -= experienceForNextLevel;
      level++;
      experienceForNextLevel = (100 * level * 1.1).toInt();
      _updateRank();
      _updateTitle();
    }
  }

  void _updateRank() {
    if (level >= 50) rank = 'Diamond';
    else if (level >= 40) rank = 'Platinum';
    else if (level >= 30) rank = 'Gold';
    else if (level >= 20) rank = 'Silver';
    else rank = 'Bronze';
  }

  void _updateTitle() {
    switch (level ~/ 10) {
      case 0:
        title = 'Novice Learner';
        break;
      case 1:
        title = 'Knowledge Seeker';
        break;
      case 2:
        title = 'Quick Learner';
        break;
      case 3:
        title = 'Brilliant Mind';
        break;
      case 4:
        title = 'Master Scholar';
        break;
      case 5:
        title = 'Legendary Sage';
        break;
      default:
        title = 'Ultimate Scholar';
    }
  }
}

// Gamification statistics
@HiveType(typeId: 18)
class GamificationStats extends HiveObject {
  @HiveField(0)
  int totalQuizzesCompleted;
  
  @HiveField(1)
  double averageQuizScore;
  
  @HiveField(2)
  int perfectScores; // 100% scores
  
  @HiveField(3)
  int totalBadgesEarned;
  
  @HiveField(4)
  int totalAchievementsUnlocked;
  
  @HiveField(5)
  int powerUpsUsed;
  
  @HiveField(6)
  int questsCompleted;
  
  @HiveField(7)
  DateTime lastPlayDate;

  GamificationStats({
    this.totalQuizzesCompleted = 0,
    this.averageQuizScore = 0,
    this.perfectScores = 0,
    this.totalBadgesEarned = 0,
    this.totalAchievementsUnlocked = 0,
    this.powerUpsUsed = 0,
    this.questsCompleted = 0,
    required this.lastPlayDate,
  });
}

// Daily quest
@HiveType(typeId: 19)
class DailyQuest extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  int reward; // points
  
  @HiveField(4)
  String questType; // 'quiz', 'study', 'review'
  
  @HiveField(5)
  int targetCount;
  
  @HiveField(6)
  int currentCount;
  
  @HiveField(7)
  bool isCompleted;
  
  @HiveField(8)
  DateTime dateIssued;
  
  @HiveField(9)
  DateTime dateExpires;

  DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.reward,
    required this.questType,
    required this.targetCount,
    this.currentCount = 0,
    this.isCompleted = false,
    required this.dateIssued,
    required this.dateExpires,
  });

  double get progress => (currentCount / targetCount * 100).clamp(0, 100);
}

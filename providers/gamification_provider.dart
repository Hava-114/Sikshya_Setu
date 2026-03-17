import 'package:flutter/material.dart';
import '../models/gamification_model.dart';
import '../models/user_model.dart';
class GamificationProvider extends ChangeNotifier {
  
  PlayerLevel _playerLevel = PlayerLevel();
  StudyStreak _studyStreak = StudyStreak(lastStudyDate: DateTime.now());
  GamificationStats _stats = GamificationStats(lastPlayDate: DateTime.now());
  
  List<GameBadge> _badges = [];
  List<Achievement> _achievements = [];
  List<DailyQuest> _dailyQuests = [];
  
  User? _currentUser;

  // Getters
  PlayerLevel get playerLevel => _playerLevel;
  StudyStreak get studyStreak => _studyStreak;
  GamificationStats get stats => _stats;
  List<GameBadge> get badges => _badges;
  List<Achievement> get achievements => _achievements;
  List<DailyQuest> get dailyQuests => _dailyQuests;
  List<DailyQuest> get activeDailyQuests => _dailyQuests.where((q) => !q.isCompleted).toList();
  List<DailyQuest> get completedDailyQuests => _dailyQuests.where((q) => q.isCompleted).toList();

  int get totalUnlockedAchievements => _achievements.where((a) => a.isUnlocked).length;

  GamificationProvider() {
    _initializeData();
  }

  void _initializeData() {
    _generateDefaultAchievements();
    _generateDailyQuests();
  }

  void setCurrentUser(User user) {
    _currentUser = user;
  }

  // Award points to user
  void awardPoints(int basePoints, {int multiplier = 1}) {
    int pointsToAward = basePoints * multiplier * _studyStreak.streakBonus;
    
    if (_currentUser != null) {
      _currentUser!.totalPoints += pointsToAward;
      _currentUser!.save();
    }
    
    // Add experience
    _playerLevel.addExperience((pointsToAward / 10).toInt());
    
    // Update stats
    _stats.lastPlayDate = DateTime.now();
    
    notifyListeners();
  }

  // Update study streak
  void updateStudyStreak() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    // Check if last study date was today
    if (_studyStreak.lastStudyDate.year == now.year &&
        _studyStreak.lastStudyDate.month == now.month &&
        _studyStreak.lastStudyDate.day == now.day) {
      return; // Already studied today
    }
    
    // Check if last study was yesterday
    if (_studyStreak.lastStudyDate.year == yesterday.year &&
        _studyStreak.lastStudyDate.month == yesterday.month &&
        _studyStreak.lastStudyDate.day == yesterday.day) {
      _studyStreak.currentStreak++;
    } else {
      _studyStreak.currentStreak = 1;
    }
    
    _studyStreak.lastStudyDate = now;
    _studyStreak.totalStudyDays++;
    
    // Update streak bonus
    if (_studyStreak.currentStreak >= 7) {
      _studyStreak.streakBonus = 3;
    } else if (_studyStreak.currentStreak >= 3) {
      _studyStreak.streakBonus = 2;
    } else {
      _studyStreak.streakBonus = 1;
    }
    
    if (_studyStreak.currentStreak > _studyStreak.longestStreak) {
      _studyStreak.longestStreak = _studyStreak.currentStreak;
    }
    
    // Award streak bonus
    if (_studyStreak.currentStreak > 1) {
      awardPoints(10 * (_studyStreak.currentStreak - 1));
    }
    
    notifyListeners();
  }

  // Unlock achievement
  void unlockAchievement(String achievementId) {
    final achievement = _achievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => Achievement(
        id: 'unknown',
        title: 'Unknown',
        description: '',
        pointsReward: 0,
        requirement: '',
        currentProgress: 0,
        targetProgress: 1,
      ),
    );
    
    if (!achievement.isUnlocked) {
      achievement.isUnlocked = true;
      achievement.unlockedDate = DateTime.now();
      
      // Award points
      awardPoints(achievement.pointsReward);
      
      // Create badge
      final badge = GameBadge(
        id: '${achievementId}_${DateTime.now().millisecondsSinceEpoch}',
        name: achievement.title,
        description: achievement.description,
        icon: _getIconForAchievement(achievementId),
        earnedDate: DateTime.now(),
        badgeType: 'achievement',
      );
      
      _badges.add(badge);
      _stats.totalBadgesEarned++;
      _stats.totalAchievementsUnlocked++;
      
      notifyListeners();
    }
  }

  // Update achievement progress
  void updateAchievementProgress(String achievementId, int progress) {
    final achievement = _achievements.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => Achievement(
        id: 'unknown',
        title: 'Unknown',
        description: '',
        pointsReward: 0,
        requirement: '',
        currentProgress: 0,
        targetProgress: 1,
      ),
    );
    
    achievement.currentProgress = progress;
    
    if (achievement.currentProgress >= achievement.targetProgress) {
      unlockAchievement(achievementId);
    }
    
    notifyListeners();
  }

  // Update daily quest progress
  void updateQuestProgress(String questId) {
    final quest = _dailyQuests.firstWhere(
      (q) => q.id == questId,
      orElse: () => DailyQuest(
        id: 'unknown',
        title: 'Unknown',
        description: '',
        reward: 0,
        questType: 'quiz',
        targetCount: 1,
        dateIssued: DateTime.now(),
        dateExpires: DateTime.now(),
      ),
    );
    
    if (!quest.isCompleted && quest.currentCount < quest.targetCount) {
      quest.currentCount++;
      
      if (quest.currentCount >= quest.targetCount) {
        quest.isCompleted = true;
        awardPoints(quest.reward);
      }
      
      notifyListeners();
    }
  }

  // Complete quiz
  void completeQuiz(int score, int totalQuestions) {
    updateStudyStreak();
    
    _stats.totalQuizzesCompleted++;
    _stats.averageQuizScore = ((_stats.averageQuizScore * (_stats.totalQuizzesCompleted - 1)) + score) / _stats.totalQuizzesCompleted;
    
    if (score == 100) {
      _stats.perfectScores++;
      awardPoints(50, multiplier: 2); // Double points for perfect scores
      unlockAchievement('perfect_score_1');
    } else if (score >= 80) {
      awardPoints(40);
    } else if (score >= 60) {
      awardPoints(30);
    } else {
      awardPoints(20);
    }
    
    // Check quiz completion milestone
    updateAchievementProgress('complete_5_quizzes', _stats.totalQuizzesCompleted);
    updateAchievementProgress('complete_10_quizzes', _stats.totalQuizzesCompleted);
    updateAchievementProgress('complete_25_quizzes', _stats.totalQuizzesCompleted);
    
    // Update quest
    updateQuestProgress('daily_quiz_quest');
    
    notifyListeners();
  }

  // Generate default achievements
  void _generateDefaultAchievements() {
    _achievements = [
      Achievement(
        id: 'first_quiz',
        title: 'First Step',
        description: 'Complete your first quiz',
        pointsReward: 10,
        requirement: 'complete_quiz',
        currentProgress: 0,
        targetProgress: 1,
      ),
      Achievement(
        id: 'perfect_score_1',
        title: 'Perfect Score',
        description: 'Get 100% on a quiz',
        pointsReward: 50,
        requirement: 'perfect_quiz',
        currentProgress: 0,
        targetProgress: 1,
      ),
      Achievement(
        id: 'complete_5_quizzes',
        title: 'Quiz Enthusiast',
        description: 'Complete 5 quizzes',
        pointsReward: 25,
        requirement: 'complete_5_quizzes',
        currentProgress: 0,
        targetProgress: 5,
      ),
      Achievement(
        id: 'complete_10_quizzes',
        title: 'Quiz Master',
        description: 'Complete 10 quizzes',
        pointsReward: 50,
        requirement: 'complete_10_quizzes',
        currentProgress: 0,
        targetProgress: 10,
      ),
      Achievement(
        id: 'complete_25_quizzes',
        title: 'Quiz Legend',
        description: 'Complete 25 quizzes',
        pointsReward: 100,
        requirement: 'complete_25_quizzes',
        currentProgress: 0,
        targetProgress: 25,
      ),
      Achievement(
        id: 'streak_3_days',
        title: 'On Fire!',
        description: 'Maintain a 3-day study streak',
        pointsReward: 30,
        requirement: 'study_streak_3',
        currentProgress: 0,
        targetProgress: 1,
      ),
      Achievement(
        id: 'streak_7_days',
        title: 'Week Warrior',
        description: 'Maintain a 7-day study streak',
        pointsReward: 75,
        requirement: 'study_streak_7',
        currentProgress: 0,
        targetProgress: 1,
      ),
      Achievement(
        id: 'level_5',
        title: 'Rising Star',
        description: 'Reach level 5',
        pointsReward: 50,
        requirement: 'reach_level_5',
        currentProgress: 0,
        targetProgress: 1,
      ),
      Achievement(
        id: 'level_10',
        title: 'Scholar',
        description: 'Reach level 10',
        pointsReward: 100,
        requirement: 'reach_level_10',
        currentProgress: 0,
        targetProgress: 1,
      ),
    ];
  }

  void _generateDailyQuests() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    
    _dailyQuests = [
      DailyQuest(
        id: 'daily_quiz_quest',
        title: 'Daily Quiz Challenge',
        description: 'Complete 2 quizzes today',
        reward: 20,
        questType: 'quiz',
        targetCount: 2,
        dateIssued: now,
        dateExpires: tomorrow,
      ),
      DailyQuest(
        id: 'daily_study_quest',
        title: 'Study Session',
        description: 'Study for 30 minutes',
        reward: 15,
        questType: 'study',
        targetCount: 30,
        dateIssued: now,
        dateExpires: tomorrow,
      ),
      DailyQuest(
        id: 'daily_perfect_quest',
        title: 'Perfection Goal',
        description: 'Get 100% on 1 quiz',
        reward: 30,
        questType: 'quiz',
        targetCount: 1,
        dateIssued: now,
        dateExpires: tomorrow,
      ),
    ];
  }

  String _getIconForAchievement(String achievementId) {
    final iconMap = {
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

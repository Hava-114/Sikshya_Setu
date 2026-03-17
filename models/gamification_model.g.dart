// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameBadgeAdapter extends TypeAdapter<GameBadge> {
  @override
  final int typeId = 14;

  @override
  GameBadge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameBadge(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      earnedDate: fields[4] as DateTime,
      badgeType: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GameBadge obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.earnedDate)
      ..writeByte(5)
      ..write(obj.badgeType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameBadgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AchievementAdapter extends TypeAdapter<Achievement> {
  @override
  final int typeId = 15;

  @override
  Achievement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Achievement(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      pointsReward: fields[3] as int,
      requirement: fields[4] as String,
      currentProgress: fields[5] as int,
      targetProgress: fields[6] as int,
      isUnlocked: fields[7] as bool,
      unlockedDate: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Achievement obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.pointsReward)
      ..writeByte(4)
      ..write(obj.requirement)
      ..writeByte(5)
      ..write(obj.currentProgress)
      ..writeByte(6)
      ..write(obj.targetProgress)
      ..writeByte(7)
      ..write(obj.isUnlocked)
      ..writeByte(8)
      ..write(obj.unlockedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StudyStreakAdapter extends TypeAdapter<StudyStreak> {
  @override
  final int typeId = 16;

  @override
  StudyStreak read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudyStreak(
      currentStreak: fields[0] as int,
      longestStreak: fields[1] as int,
      lastStudyDate: fields[2] as DateTime,
      totalStudyDays: fields[3] as int,
      streakBonus: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StudyStreak obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.currentStreak)
      ..writeByte(1)
      ..write(obj.longestStreak)
      ..writeByte(2)
      ..write(obj.lastStudyDate)
      ..writeByte(3)
      ..write(obj.totalStudyDays)
      ..writeByte(4)
      ..write(obj.streakBonus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudyStreakAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayerLevelAdapter extends TypeAdapter<PlayerLevel> {
  @override
  final int typeId = 17;

  @override
  PlayerLevel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerLevel(
      level: fields[0] as int,
      totalExperience: fields[1] as int,
      experienceForNextLevel: fields[2] as int,
      title: fields[3] as String,
      rank: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerLevel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.totalExperience)
      ..writeByte(2)
      ..write(obj.experienceForNextLevel)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.rank);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GamificationStatsAdapter extends TypeAdapter<GamificationStats> {
  @override
  final int typeId = 18;

  @override
  GamificationStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GamificationStats(
      totalQuizzesCompleted: fields[0] as int,
      averageQuizScore: fields[1] as double,
      perfectScores: fields[2] as int,
      totalBadgesEarned: fields[3] as int,
      totalAchievementsUnlocked: fields[4] as int,
      powerUpsUsed: fields[5] as int,
      questsCompleted: fields[6] as int,
      lastPlayDate: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GamificationStats obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.totalQuizzesCompleted)
      ..writeByte(1)
      ..write(obj.averageQuizScore)
      ..writeByte(2)
      ..write(obj.perfectScores)
      ..writeByte(3)
      ..write(obj.totalBadgesEarned)
      ..writeByte(4)
      ..write(obj.totalAchievementsUnlocked)
      ..writeByte(5)
      ..write(obj.powerUpsUsed)
      ..writeByte(6)
      ..write(obj.questsCompleted)
      ..writeByte(7)
      ..write(obj.lastPlayDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GamificationStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyQuestAdapter extends TypeAdapter<DailyQuest> {
  @override
  final int typeId = 19;

  @override
  DailyQuest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyQuest(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      reward: fields[3] as int,
      questType: fields[4] as String,
      targetCount: fields[5] as int,
      currentCount: fields[6] as int,
      isCompleted: fields[7] as bool,
      dateIssued: fields[8] as DateTime,
      dateExpires: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DailyQuest obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.reward)
      ..writeByte(4)
      ..write(obj.questType)
      ..writeByte(5)
      ..write(obj.targetCount)
      ..writeByte(6)
      ..write(obj.currentCount)
      ..writeByte(7)
      ..write(obj.isCompleted)
      ..writeByte(8)
      ..write(obj.dateIssued)
      ..writeByte(9)
      ..write(obj.dateExpires);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyQuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

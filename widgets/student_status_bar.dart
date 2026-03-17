import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gamification_provider.dart';
import '../providers/app_provider.dart';

class StudentStatusBar extends StatelessWidget {
  final bool compact;

  const StudentStatusBar({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<GamificationProvider, AppProvider>(
      builder: (context, gamificationProvider, appProvider, _) {
        return Container(
          padding: EdgeInsets.all(compact ? 8 : 12),
          color: Colors.blue[50],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Points
              _buildStatusItem(
                icon: Icons.star,
                label: 'Points',
                value: '${appProvider.currentUser?.totalPoints ?? 0}',
                color: Colors.amber,
              ),
              // Level
              _buildStatusItem(
                icon: Icons.trending_up,
                label: 'Level',
                value: '${gamificationProvider.playerLevel.level}',
                color: Colors.blue,
              ),
              // Streak
              _buildStatusItem(
                icon: Icons.local_fire_department,
                label: 'Streak',
                value: '${gamificationProvider.studyStreak.currentStreak}',
                color: Colors.red,
              ),
              // Achievements
              _buildStatusItem(
                icon: Icons.emoji_events,
                label: 'Achievements',
                value: '${gamificationProvider.totalUnlockedAchievements}',
                color: Colors.purple,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: compact ? 18 : 22),
        const SizedBox(height: 2),
        if (!compact)
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        Text(
          value,
          style: TextStyle(
            fontSize: compact ? 12 : 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
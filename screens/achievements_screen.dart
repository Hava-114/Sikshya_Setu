import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/gamification_widgets.dart';
import '../providers/gamification_provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACHIEVEMENTS'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      drawer: const CustomDrawer(),
      body: Consumer<GamificationProvider>(
        builder: (context, gamificationProvider, _) {
          final achievements = gamificationProvider.achievements;
          final unlockedAchievements =
              achievements.where((a) => a.isUnlocked).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStat(
                              '${unlockedAchievements.length}',
                              'Unlocked',
                              Icons.emoji_events,
                            ),
                            _buildStat(
                              '${achievements.length - unlockedAchievements.length}',
                              'Locked',
                              Icons.lock,
                            ),
                            _buildStat(
                              '${unlockedAchievements.fold<int>(0, (sum, a) => sum + a.pointsReward)} pts',
                              'Total Rewards',
                              Icons.stars,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Level Info
                const Text(
                  'Current Level',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                PlayerLevelCard(
                  playerLevel: gamificationProvider.playerLevel,
                ),
                const SizedBox(height: 24),

                // Streak Info
                const Text(
                  'Study Streak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                StreakWidget(streak: gamificationProvider.studyStreak),
                const SizedBox(height: 24),

                // Achievements
                const Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: achievements.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AchievementCard(
                        achievement: achievements[index],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Badges Section
                const Text(
                  'Badges Earned',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (gamificationProvider.badges.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 48,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No badges earned yet',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: gamificationProvider.badges
                        .map((badge) => BadgeWidget(badge: badge))
                        .toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4A90E2), size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

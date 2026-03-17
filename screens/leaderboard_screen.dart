import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';
import '../providers/gamification_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  final List<Map<String, dynamic>> leaderboardData = const [
    {'rank': 1, 'name': 'Rajesh Kumar', 'points': 245, 'badges': 5},
    {'rank': 2, 'name': 'Priya Sharma', 'points': 220, 'badges': 4},
    {'rank': 3, 'name': 'Amit Patel', 'points': 195, 'badges': 3},
    {'rank': 4, 'name': 'Sneha Gupta', 'points': 180, 'badges': 3},
    {'rank': 5, 'name': 'You', 'points': 165, 'badges': 2},
    {'rank': 6, 'name': 'Ravi Verma', 'points': 140, 'badges': 2},
    {'rank': 7, 'name': 'Anjali Singh', 'points': 120, 'badges': 1},
    {'rank': 8, 'name': 'Mohit Joshi', 'points': 95, 'badges': 1},
    {'rank': 9, 'name': 'Neha Reddy', 'points': 75, 'badges': 1},
    {'rank': 10, 'name': 'Karan Malhotra', 'points': 50, 'badges': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEADERBOARD'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      drawer: const CustomDrawer(),
      body: Consumer<GamificationProvider>(
        builder: (context, gamificationProvider, _) {
          return Column(
            children: [
              // Top 3 winners
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.blue[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTopWinner(2, leaderboardData[1], gamificationProvider),
                    _buildTopWinner(1, leaderboardData[0], gamificationProvider),
                    _buildTopWinner(3, leaderboardData[2], gamificationProvider),
                  ],
                ),
              ),
              // Leaderboard list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: leaderboardData.length,
                  itemBuilder: (context, index) {
                    final data = leaderboardData[index];
                    final isCurrentUser = data['name'] == 'You';
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: isCurrentUser ? Colors.blue[50] : Colors.white,
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _getRankColor(data['rank']),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${data['rank']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: data['rank'] <= 3 ? 18 : 16,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                data['name'],
                                style: TextStyle(
                                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                                  color: isCurrentUser ? Colors.blue : Colors.black,
                                ),
                              ),
                            ),
                            if (isCurrentUser)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Lvl ${gamificationProvider.playerLevel.level}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data['points']} points • ${data['badges']} badges',
                            ),
                            if (isCurrentUser)
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    size: 14,
                                    color: Colors.red[400],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${gamificationProvider.studyStreak.currentStreak} day streak',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red[400],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (data['rank'] <= 3)
                              const Icon(
                                Icons.emoji_events,
                                color: Colors.amber,
                              ),
                            const SizedBox(width: 8),
                            _buildBadges(data['badges']),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Total Students', '10'),
                    _buildStat('Top Score', '245'),
                    _buildStat('Avg Score', '148'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopWinner(int rank, Map<String, dynamic> data, GamificationProvider gamificationProvider) {
    double size = rank == 1 ? 120 : 100;
    double iconSize = rank == 1 ? 40 : 30;
    
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: size / 2,
              backgroundColor: _getRankColor(rank),
              child: CircleAvatar(
                radius: (size / 2) - 4,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: iconSize,
                  color: Colors.grey,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: _getRankColor(rank),
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          data['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          '${data['points']} pts',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBadges(int count) {
    if (count == 0) return const SizedBox();
    
    return Row(
      children: List.generate(count, (index) {
        return Container(
          margin: const EdgeInsets.only(left: 2),
          child: const Icon(
            Icons.star,
            size: 16,
            color: Colors.amber,
          ),
        );
      }),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A90E2),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.orange[700]!;
      default:
        return Colors.blue;
    }
  }
}
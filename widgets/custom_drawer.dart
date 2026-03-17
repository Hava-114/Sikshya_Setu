import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF4A90E2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.school,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  provider.currentUser?.username ?? 'Student',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Points: ${provider.currentUser?.totalPoints ?? 0}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Chapters'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/chapters');
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Quiz'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/quiz');
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text('Leaderboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/leaderboard');
            },
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Achievements'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/achievements');
            },
          ),
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('Daily Quests'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/daily-quests');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              provider.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
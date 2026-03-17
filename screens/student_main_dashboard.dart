import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_tutor_provider.dart';
import '../providers/offline_quiz_provider.dart';
import '../providers/weak_topic_provider.dart';

import '../screens/ai_tutor_screen.dart';
import '../screens/offline_quiz_practice_screen.dart';
import '../screens/weak_topics_dashboard.dart';
import '../widgets/connectivity_indicator.dart';

class StudentMainDashboard extends StatefulWidget {
  const StudentMainDashboard({Key? key}) : super(key: key);

  @override
  State<StudentMainDashboard> createState() => _StudentMainDashboardState();
}

class _StudentMainDashboardState extends State<StudentMainDashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  void _initializeProviders() {
    // Initialize all providers
    final aiTutorProvider = Provider.of<AiTutorProvider>(context, listen: false);
    final quizProvider = Provider.of<OfflineQuizProvider>(context, listen: false);
    final weakProvider = Provider.of<WeakTopicProvider>(context, listen: false);

    aiTutorProvider.initialize();
    quizProvider.initialize();
    weakProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Learning Hub'),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: ConnectivityIndicator(showLabel: true),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'AI Tutor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const AiTutorScreen();
      case 1:
        return const OfflineQuizPracticeScreen();
      case 2:
        return const WeakTopicsDashboard();
      default:
        return const AiTutorScreen();
    }
  }
}

// Splash/Selection screen for choosing between Student and Teacher modes
class AppModeSelectionScreen extends StatelessWidget {
  const AppModeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school,
                    size: 80,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sikshya Setu',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Offline Learning Platform',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Student Mode
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/student-dashboard');
                      },
                      icon: const Icon(Icons.person, size: 28),
                      label: const Text(
                        'Student Mode',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'AI Tutor • Practice Quiz • Analytics',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Teacher Mode
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/teacher-login');
                      },
                      icon: const Icon(Icons.admin_panel_settings, size: 28),
                      label: const Text(
                        'Teacher Mode',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'View Progress • Send Notes • Sync Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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
}

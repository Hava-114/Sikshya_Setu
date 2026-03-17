import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import screens
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chapters_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/daily_quests_screen.dart';
import 'screens/teacher/teacher_login_screen.dart';
import 'screens/teacher/teacher_dashboard.dart';

// Import providers
import 'providers/app_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/teacher_provider.dart';
import 'providers/gamification_provider.dart';

// Import models
import 'models/user_model.dart';
import 'models/quiz_model.dart';
import 'models/teacher_model.dart';
import 'models/content_model.dart' as content;
import 'models/gamification_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(QuizAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(QuizResultAdapter());
  Hive.registerAdapter(TeacherAdapter());
  Hive.registerAdapter(StudentProgressAdapter());
  Hive.registerAdapter(content.StudyMaterialAdapter());
  Hive.registerAdapter(content.ChapterContentAdapter());
  Hive.registerAdapter(content.MaterialTypeAdapter());
  Hive.registerAdapter(content.AnnouncementAdapter());
  Hive.registerAdapter(content.AssignmentAdapter());
  Hive.registerAdapter(GameBadgeAdapter());
  Hive.registerAdapter(AchievementAdapter());
  Hive.registerAdapter(StudyStreakAdapter());
  Hive.registerAdapter(PlayerLevelAdapter());
  Hive.registerAdapter(GamificationStatsAdapter());
  Hive.registerAdapter(DailyQuestAdapter());
  
  // Open boxes
  await Hive.openBox<User>('userBox');
  await Hive.openBox<Quiz>('quizBox');
  await Hive.openBox<QuizResult>('resultBox');
  await Hive.openBox<Teacher>('teacherBox');
  
  runApp(const SikshyaSetuApp());
}

class SikshyaSetuApp extends StatelessWidget {
  const SikshyaSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
      ],
      child: MaterialApp(
        title: 'SIKHYA SETU',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF4A90E2),
            elevation: 0,
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        home: const AppEntryScreen(), // Changed to entry screen
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const HomeScreen(),
          '/chapters': (context) => const ChaptersScreen(),
          '/quiz': (context) => const QuizScreen(),
          '/leaderboard': (context) => const LeaderboardScreen(),
          '/achievements': (context) => const AchievementsScreen(),
          '/daily-quests': (context) => const DailyQuestsScreen(),
          '/teacher-login': (context) => const TeacherLoginScreen(),
          '/teacher-dashboard': (context) => const TeacherDashboard(),
        },
      ),
    );
  }
}

class AppEntryScreen extends StatelessWidget {
  const AppEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isStudentLoggedIn = Provider.of<AppProvider>(context).isLoggedIn;
    final isTeacherLoggedIn = Provider.of<TeacherProvider>(context).isTeacherLoggedIn;

    if (isStudentLoggedIn) {
      return const HomeScreen();
    } else if (isTeacherLoggedIn) {
      return const TeacherDashboard();
    } else {
      return const LoginChoiceScreen();
    }
  }
}

class LoginChoiceScreen extends StatelessWidget {
  const LoginChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const Icon(
                Icons.school,
                size: 80,
                color: Color(0xFF4A90E2),
              ),
              const SizedBox(height: 20),
              
              // Title
              const Text(
                'SIKHYA SETU',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Digital Learning Platform',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              
              // Student Login Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue[100],
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Student Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Access learning materials, quizzes, and chatbot',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Teacher Login Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeacherLoginScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green[100],
                          child: const Icon(
                            Icons.school,
                            size: 40,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Teacher Portal',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Monitor students, upload content, manage curriculum',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
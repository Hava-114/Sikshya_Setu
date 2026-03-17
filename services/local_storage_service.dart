import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/quiz_model.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  late Box<User> _userBox;
  late Box<Quiz> _quizBox;
  late Box<QuizResult> _resultBox;
  late SharedPreferences _prefs;

  Future<void> init() async {
    _userBox = Hive.box<User>('userBox');
    _quizBox = Hive.box<Quiz>('quizBox');
    _resultBox = Hive.box<QuizResult>('resultBox');
    _prefs = await SharedPreferences.getInstance();
  }

  // User operations
  Future<void> saveUser(User user) async {
    await _userBox.put(user.username, user);
  }

  User? getUser(String username) {
    return _userBox.get(username);
  }

  // Quiz operations
  Future<void> saveQuiz(Quiz quiz) async {
    await _quizBox.put(quiz.id, quiz);
  }

  List<Quiz> getAllQuizzes() {
    return _quizBox.values.toList();
  }

  // Result operations
  Future<void> saveQuizResult(QuizResult result) async {
    await _resultBox.add(result);
  }

  List<QuizResult> getUserResults(String userId) {
    return _resultBox.values
        .where((result) => result.userId == userId)
        .toList();
  }

  // SharedPreferences for app state
  Future<void> setLoggedIn(bool value) async {
    await _prefs.setBool('isLoggedIn', value);
  }

  bool getLoggedIn() {
    return _prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> setCurrentUser(String username) async {
    await _prefs.setString('currentUser', username);
  }

  String? getCurrentUser() {
    return _prefs.getString('currentUser');
  }
}
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/local_storage_service.dart';

class AppProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  final LocalStorageService _storageService = LocalStorageService();

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  AppProvider() {
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    await _storageService.init();
    
    final savedLoggedIn = _storageService.getLoggedIn();
    final savedUsername = _storageService.getCurrentUser();
    
    if (savedLoggedIn && savedUsername != null) {
      final user = _storageService.getUser(savedUsername);
      if (user != null) {
        _currentUser = user;
        _isLoggedIn = true;
        notifyListeners();
      }
    }
  }

  Future<void> login(String username, String password) async {
    // For prototype: Create user if doesn't exist
    User user = _storageService.getUser(username) ?? User(
      username: username,
      name: 'Student ${username.substring(0, 3)}',
      totalPoints: 0,
      completedQuizzes: [],
      badges: [],
    );

    // Save user to storage
    await _storageService.saveUser(user);
    await _storageService.setLoggedIn(true);
    await _storageService.setCurrentUser(username);

    // Update provider state
    _currentUser = user;
    _isLoggedIn = true;
    
    notifyListeners();
  }

  Future<void> logout() async {
    await _storageService.setLoggedIn(false);
    await _storageService.setCurrentUser('');
    
    _currentUser = null;
    _isLoggedIn = false;
    
    notifyListeners();
  }

  void updateUserPoints(int points) {
    if (_currentUser != null) {
      _currentUser!.totalPoints += points;
      _storageService.saveUser(_currentUser!);
      notifyListeners();
    }
  }

  void addCompletedQuiz(String quizId) {
    if (_currentUser != null) {
      if (!_currentUser!.completedQuizzes.contains(quizId)) {
        _currentUser!.completedQuizzes.add(quizId);
        _storageService.saveUser(_currentUser!);
        notifyListeners();
      }
    }
  }

  void addBadge(String badgeId, String badgeName) {
    if (_currentUser != null) {
      // For prototype, we'll just track badge IDs in the badges list
      if (!_currentUser!.badges.contains(badgeId)) {
        _currentUser!.badges.add(badgeId);
        _storageService.saveUser(_currentUser!);
        notifyListeners();
      }
    }
  }
}
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  ConnectivityProvider() {
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectivity);
  }

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectivity(ConnectivityResult result) {
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final wasOnline = _isOnline;
    _isOnline = result != ConnectivityResult.none;
    
    if (wasOnline != _isOnline) {
      notifyListeners();
    }
  }

  // Trigger sync when back online
  void onBackOnline() {
    // This will be called when connection is restored
    notifyListeners();
  }
}

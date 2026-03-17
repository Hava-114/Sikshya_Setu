import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class SyncMessage {
  final String id;
  final String type; // 'note', 'homework', 'message'
  final String studentId;
  final String teacherId;
  final String content;
  final String title;
  final DateTime createdAt;
  final DateTime? dueDate;
  bool isSynced;

  SyncMessage({
    String? id,
    required this.type,
    required this.studentId,
    required this.teacherId,
    required this.content,
    required this.title,
    DateTime? createdAt,
    this.dueDate,
    this.isSynced = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'studentId': studentId,
    'teacherId': teacherId,
    'content': content,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'isSynced': isSynced,
  };

  factory SyncMessage.fromJson(Map<String, dynamic> json) => SyncMessage(
    id: json['id'],
    type: json['type'],
    studentId: json['studentId'],
    teacherId: json['teacherId'],
    content: json['content'],
    title: json['title'],
    createdAt: DateTime.parse(json['createdAt']),
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    isSynced: json['isSynced'] ?? false,
  );
}

class SyncManagerService extends ChangeNotifier {
  final String _boxName = 'sync_messages';
  late Box<String> _syncBox;
  
  List<SyncMessage> _pendingSync = [];
  List<SyncMessage> _syncedMessages = [];
  bool _isSyncing = false;
  String? _lastSyncTime;
  String? _error;

  List<SyncMessage> get pendingSync => _pendingSync;
  List<SyncMessage> get syncedMessages => _syncedMessages;
  bool get isSyncing => _isSyncing;
  String? get lastSyncTime => _lastSyncTime;
  String? get error => _error;
  int get pendingSyncCount => _pendingSync.length;

  Future<void> initialize() async {
    try {
      _syncBox = await Hive.openBox<String>(_boxName);
      await _loadMessages();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize sync service: $e';
      notifyListeners();
    }
  }

  // Add a message to be synced later
  Future<void> addMessageForSync(SyncMessage message) async {
    try {
      _pendingSync.add(message);
      await _saveMessages();
      notifyListeners();
    } catch (e) {
      _error = 'Error adding message: $e';
      notifyListeners();
    }
  }

  // Send note to student (queued for sync)
  Future<void> sendNote({
    required String studentId,
    required String teacherId,
    required String title,
    required String content,
  }) async {
    final message = SyncMessage(
      type: 'note',
      studentId: studentId,
      teacherId: teacherId,
      title: title,
      content: content,
    );
    await addMessageForSync(message);
  }

  // Send homework to student (queued for sync)
  Future<void> sendHomework({
    required String studentId,
    required String teacherId,
    required String title,
    required String content,
    required DateTime dueDate,
  }) async {
    final message = SyncMessage(
      type: 'homework',
      studentId: studentId,
      teacherId: teacherId,
      title: title,
      content: content,
      dueDate: dueDate,
    );
    await addMessageForSync(message);
  }

  // Send message to student (queued for sync)
  Future<void> sendMessage({
    required String studentId,
    required String teacherId,
    required String content,
  }) async {
    final message = SyncMessage(
      type: 'message',
      studentId: studentId,
      teacherId: teacherId,
      title: 'Message from Teacher',
      content: content,
    );
    await addMessageForSync(message);
  }

  // Sync all pending messages when online
  Future<bool> syncAllPending() async {
    if (_pendingSync.isEmpty) return true;
    
    _isSyncing = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call when backend is ready
      // For now, we'll simulate syncing by marking messages as synced after a delay
      await Future.delayed(const Duration(seconds: 2));

      for (var message in _pendingSync) {
        message.isSynced = true;
        _syncedMessages.add(message);
      }
      _pendingSync.clear();
      _lastSyncTime = DateTime.now().toString();
      await _saveMessages();
      return true;
    } catch (e) {
      _error = 'Sync failed: $e';
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> _loadMessages() async {
    try {
      final pendingJson = _syncBox.get('pending');
      final syncedJson = _syncBox.get('synced');
      _lastSyncTime = _syncBox.get('lastSyncTime');

      if (pendingJson != null) {
        final list = jsonDecode(pendingJson) as List;
        _pendingSync = list
            .map((item) => SyncMessage.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      if (syncedJson != null) {
        final list = jsonDecode(syncedJson) as List;
        _syncedMessages = list
            .map((item) => SyncMessage.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  Future<void> _saveMessages() async {
    try {
      await _syncBox.put('pending', jsonEncode(
        _pendingSync.map((m) => m.toJson()).toList(),
      ));
      await _syncBox.put('synced', jsonEncode(
        _syncedMessages.map((m) => m.toJson()).toList(),
      ));
      if (_lastSyncTime != null) {
        await _syncBox.put('lastSyncTime', _lastSyncTime!);
      }
    } catch (e) {
      debugPrint('Error saving messages: $e');
    }
  }

  void clearSyncHistory() {
    _syncedMessages = [];
    _saveMessages();
    notifyListeners();
  }

  @override
  void dispose() {
    _syncBox.close();
    super.dispose();
  }
}

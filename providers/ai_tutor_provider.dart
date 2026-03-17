import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart' as Config;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class ChatMessage {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;
  final String? topic;

  ChatMessage({
    String? id,
    required this.role,
    required this.content,
    DateTime? timestamp,
    this.topic,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'topic': topic,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'],
    role: json['role'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    topic: json['topic'],
  );
}

class AiTutorProvider extends ChangeNotifier {
  // FIXED: Use Config.baseUrl from config.dart
  final String baseUrl = Config.baseUrl; // comes from config.dart
  
  // FIXED: Make these private with underscore
  final String _boxName = 'ai_chat_history';
  
  List<ChatMessage> _chatHistory = [];
  String _currentTopic = '';
  bool _isLoading = false;
  bool _isOllamaAvailable = false;
  String? _error;
  late Box<String> _chatBox;

  // Getters
  List<ChatMessage> get chatHistory => _chatHistory;
  String get currentTopic => _currentTopic;
  bool get isLoading => _isLoading;
  bool get isOllamaAvailable => _isOllamaAvailable;
  String? get error => _error;

  // Popular topics for offline AI tutoring
  final List<String> availableTopics = [
    'Mathematics: Algebra',
    'Mathematics: Geometry',
    'Mathematics: Trigonometry',
    'Mathematics: Calculus',
    'Physics: Mechanics',
    'Physics: Thermodynamics',
    'Physics: Optics',
    'Chemistry: Organic Chemistry',
    'Chemistry: Inorganic Chemistry',
    'Chemistry: Physical Chemistry',
    'Biology: Cell Biology',
    'Biology: Genetics',
    'Biology: Ecology',
    'History: Ancient History',
    'History: Modern History',
    'Geography: World Geography',
    'Literature: English Grammar',
    'Literature: Essay Writing',
    'Science: General Knowledge',
    'Custom Topic'
  ];

  Future<void> initialize() async {
    try {
      _chatBox = await Hive.openBox<String>(_boxName);
      await _loadChatHistory();
      await _checkOllamaAvailability();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize: $e';
      notifyListeners();
    }
  }

  Future<void> _checkOllamaAvailability() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/')) // Changed from /health to /
          .timeout(const Duration(seconds: 5));
      _isOllamaAvailable = response.statusCode == 200;
    } catch (e) {
      _isOllamaAvailable = false;
      debugPrint('Ollama not available: $e');
    }
    notifyListeners();
  }

  Future<void> setTopic(String topic) async {
    _currentTopic = topic;
    _chatHistory = [];
    _error = null;
    await _loadChatHistory();
    notifyListeners();
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    // Add user message
    final userMsg = ChatMessage(
      role: 'user',
      content: userMessage,
      topic: _currentTopic,
    );
    _chatHistory.add(userMsg);
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // First check if Ollama is available
      if (!_isOllamaAvailable) {
        // Use local fallback
        await _getLocalResponse(userMessage);
      } else {
        // Get AI response from Ollama via FastAPI
        final response = await http.post(
          Uri.parse('$baseUrl/ask'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'question': userMessage,
            'topic': _currentTopic,
            'context': _getChatContext(),
          }),
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final aiMessage = ChatMessage(
            role: 'assistant',
            content: data['answer'] ?? data['response'] ?? 'No response received',
            topic: _currentTopic,
          );
          _chatHistory.add(aiMessage);
          await _saveChatHistory();
        } else {
          throw Exception('Failed to get response: ${response.statusCode}');
        }
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
      debugPrint('Chat error: $e');
      
      // Fallback response
      final fallbackMessage = ChatMessage(
        role: 'assistant',
        content: _getFallbackResponse(userMessage),
        topic: _currentTopic,
      );
      _chatHistory.add(fallbackMessage);
      await _saveChatHistory();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // FIXED: Added local response method
  Future<void> _getLocalResponse(String userMessage) async {
    // Simulate thinking delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final response = _getFallbackResponse(userMessage);
    
    final aiMessage = ChatMessage(
      role: 'assistant',
      content: response,
      topic: _currentTopic,
    );
    _chatHistory.add(aiMessage);
    await _saveChatHistory();
  }

  // FIXED: Added fallback responses
  String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return "Hello! How can I help you with your studies today?";
    }
    if (lowerMessage.contains('algebra')) {
      return "Algebra is the study of mathematical symbols and rules. For example, in 2x + 3 = 7, we solve for x by subtracting 3 from both sides: 2x = 4, then divide by 2: x = 2.";
    }
    if (lowerMessage.contains('geometry')) {
      return "Geometry deals with shapes, sizes, and properties of space. The area of a rectangle is length × width, while the Pythagorean theorem states a² + b² = c² for right triangles.";
    }
    if (lowerMessage.contains('physics') || lowerMessage.contains('gravity')) {
      return "Physics is the study of matter, energy, and forces. Gravity is 9.8 m/s² on Earth, pulling objects toward the ground. Newton's laws describe motion and forces.";
    }
    if (lowerMessage.contains('chemistry')) {
      return "Chemistry studies matter and its reactions. Water is H₂O, consisting of 2 hydrogen atoms and 1 oxygen atom. The pH scale measures acidity (0-14).";
    }
    if (lowerMessage.contains('biology') || lowerMessage.contains('cell')) {
      return "Biology is the study of life. Cells are the basic unit of life. Photosynthesis is how plants make food: 6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂.";
    }
    
    return "I'm your AI tutor! I can help you with math, science, and other subjects. Please ask me a specific question about a topic you'd like to learn.";
  }

  String _getChatContext() {
    // Provide context from recent chat messages
    if (_chatHistory.isEmpty) return '';
    
    final recentMessages = _chatHistory.length > 4 
        ? _chatHistory.skip(_chatHistory.length - 4).map((m) => '${m.role}: ${m.content}').join('\n')
        : _chatHistory.map((m) => '${m.role}: ${m.content}').join('\n');
    return recentMessages;
  }

  Future<void> _saveChatHistory() async {
    try {
      final topicKey = _currentTopic.isEmpty ? 'general' : _currentTopic;
      final jsonList = jsonEncode(_chatHistory.map((m) => m.toJson()).toList());
      await _chatBox.put(topicKey, jsonList);
    } catch (e) {
      debugPrint('Error saving chat history: $e');
    }
  }

  Future<void> _loadChatHistory() async {
    try {
      final topicKey = _currentTopic.isEmpty ? 'general' : _currentTopic;
      final jsonString = _chatBox.get(topicKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final jsonList = jsonDecode(jsonString) as List;
        _chatHistory = jsonList
            .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading chat history: $e');
      _chatHistory = [];
    }
  }

  Future<void> clearChatHistory() async {
    _chatHistory = [];
    try {
      final topicKey = _currentTopic.isEmpty ? 'general' : _currentTopic;
      await _chatBox.delete(topicKey);
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
    notifyListeners();
  }

  Future<void> clearAllHistory() async {
    try {
      await _chatBox.clear();
      _chatHistory = [];
    } catch (e) {
      debugPrint('Error clearing all history: $e');
    }
    notifyListeners();
  }

  // Get explanation for a concept
  Future<String> getExplanation(String concept) async {
    try {
      if (!_isOllamaAvailable) {
        return _getFallbackResponse(concept);
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/ask'), // Changed from /explain to /ask
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': concept,
          'topic': _currentTopic,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['answer'] ?? data['response'] ?? 'No explanation available';
      }
      return 'Error getting explanation';
    } catch (e) {
      return _getFallbackResponse(concept);
    }
  }

  // Solve doubts with examples
  Future<String> solveDoubt(String doubt) async {
    try {
      if (!_isOllamaAvailable) {
        return _getFallbackResponse(doubt);
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/ask'), // Changed from /solve to /ask
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': doubt,
          'topic': _currentTopic,
          'previous_context': _getChatContext(),
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['answer'] ?? data['response'] ?? 'No solution available';
      }
      return 'Error solving doubt';
    } catch (e) {
      return _getFallbackResponse(doubt);
    }
  }

  @override
  void dispose() {
    _chatBox.close();
    super.dispose();
  }
}
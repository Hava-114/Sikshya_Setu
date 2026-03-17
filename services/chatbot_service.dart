import 'dart:convert';
import 'package:flutter/services.dart';
import '../services/local_data_services.dart';
import '../services/ollama_setup.dart';

class ChatbotService {
  final OllamaService? _ollamaService;
  final bool _useLocalOnly = true;  // Hardcoded to true - always use local data

  // Simple constructor - no parameters needed
  ChatbotService([this._ollamaService]) {
    print('🔧 ChatbotService initialized (local only: $_useLocalOnly)');
  }

  // Get response using local data service
  Future<String> getResponse(String userInput, {String subject = 'general'}) async {
    print('📤 Processing: "$userInput" (subject: $subject)');
    
    try {
      await Future.delayed(const Duration(seconds: 3));
      String response = LocalDataService.getResponse(userInput, subject: subject);
      print('✅ Response generated');
      return response;
      
    } catch (e) {
      print("❌ Error in getResponse: $e");
      return "I'm your learning assistant! Please ask me about math, science, or cyber security topics.";
    }
  }

  // Get story mode response
  Future<String> getStoryResponse(String userInput, {String subject = 'general'}) async {
    try {
      String answer = LocalDataService.getResponse(userInput, subject: subject);
      
      return "Let me tell you a story about $userInput:\n\n"
             "Once upon a time, a curious student asked their teacher: '$userInput'\n\n"
             "The wise teacher smiled and explained: $answer\n\n"
             "The student's eyes lit up with understanding!\n\n"
             "And that's how learning happens - one question at a time!";
      
    } catch (e) {
      print("❌ Error in story mode: $e");
      return "I'd love to tell you a story! Please ask me a specific question.";
    }
  }

  // Get random practice question
  Map<String, String> getRandomQuestion({String? subject}) {
    try {
      return LocalDataService.getRandomQuestion(subject: subject);
    } catch (e) {
      print('❌ Error getting random question: $e');
      return {
        'question': 'What is 2+2?',
        'answer': '4',
        'category': 'math'
      };
    }
  }

  // Get all available topics
  List<String> getAvailableTopics() {
    return [
      "Algebra",
      "Arithmetic",
      "Geometry",
      "Trigonometry",
      "Calculus",
      "Physics",
      "Chemistry",
      "Biology",
      "Trojans",
      "Viruses",
      "Worms",
      "Ransomware",
      "Phishing",
      "DDoS",
      "Malware",
      "Spyware",
      "Keylogger",
      "Encryption",
      "Hackers",
      "Firewalls",
      "Botnet",
      "Cyber Security"
    ];
  }
  
  int min(int a, int b) => a < b ? a : b;
}
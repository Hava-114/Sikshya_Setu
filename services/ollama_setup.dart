import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../services/local_data_services.dart';  // Your exact import path
import '../config.dart' as Config;  // Make sure this import is correct

class OllamaService {
  final String baseUrl;
  final bool useLocalOnly;
  
  OllamaService({String? customUrl, this.useLocalOnly = true})
      : baseUrl = customUrl ?? Config.baseUrl {
    debugPrint('🔧 OllamaService initialized with local only: $useLocalOnly');
  }
  
  // Send message with local data only
  Future<Map<String, dynamic>> sendMessage(String message, {String subject = 'general'}) async {
    debugPrint('📚 Using LocalDataService for: "$message"');
    
    try {
      String response = LocalDataService.getResponse(message, subject: subject);
      
      return {
        'success': true,
        'message': response,
        'source': 'local'
      };
    } catch (e) {
      debugPrint('❌ Error using LocalDataService: $e');
      
      return {
        'success': true,
        'message': "I'm your learning assistant! I can help with math, science, and cyber security topics.",
        'source': 'fallback'
      };
    }
  }
  
  // Send message with story mode
  Future<Map<String, dynamic>> sendStoryMessage(String message, {String subject = 'general'}) async {
    debugPrint('📚 Using LocalDataService for story mode: "$message"');
    
    try {
      String response = LocalDataService.getResponse(message, subject: subject);
      
      String storyResponse = "Let me tell you a story about $message:\n\n"
          "Once upon a time, a curious student asked: '$message'\n\n"
          "The wise teacher explained: $response\n\n"
          "And this discovery helped everyone understand better!";
      
      return {
        'success': true,
        'message': storyResponse,
        'source': 'local_story'
      };
    } catch (e) {
      debugPrint('❌ Error in story mode: $e');
      return {
        'success': true,
        'message': "I'd love to tell you a story! Please ask me a specific question about math, science, or cyber security.",
        'source': 'fallback'
      };
    }
  }
  
  // Test connection
  Future<bool> testConnection() async {
    debugPrint('📚 Local mode - skipping connection test');
    return true;
  }
}
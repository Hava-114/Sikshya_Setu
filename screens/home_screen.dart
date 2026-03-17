import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/chat_bubble.dart';
import '../providers/gamification_provider.dart';
import '../services/chatbot_service.dart';
import '../services/ollama_setup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late final ChatbotService _chatbotService;
  bool _isLoading = false;
  String _currentSubject = 'general';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Initialize with local-only mode
    final ollamaService = OllamaService(useLocalOnly: true);
    _chatbotService = ChatbotService(ollamaService);

    // Add welcome message
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add({
        'text': 'Hello! 👋 I\'m your learning assistant. I can help you with:\n\n'
                '📐 **Mathematics** (Algebra, Arithmetic, Geometry)\n'
                '🔬 **Science** (Physics, Chemistry, Biology)\n\n'
                'What would you like to learn about?',
        'isUser': false,
        'time': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

Future<void> _sendMessage() async {
  if (_messageController.text.isEmpty) return;

  final userMessage = _messageController.text;
  _messageController.clear();

  // Add user message
  setState(() {
    _messages.add({
      'text': userMessage,
      'isUser': true,
      'time': DateTime.now(),
    });
    _isLoading = true;
  });
  
  _scrollToBottom();

  try {
    // Get response from chatbot service
    print('📤 Sending to chatbot: "$userMessage"');
    final response = await _chatbotService.getResponse(
  userMessage,
  subject: _currentSubject, // Make sure this is set correctly
);
    print('📥 Got response: "$response"');

    // Add bot response
    setState(() {
      _messages.add({
        'text': response,
        'isUser': false,
        'time': DateTime.now(),
        'source': 'local',
      });
      _isLoading = false;
    });
    
    _scrollToBottom();

    // Award XP for asking a question (gamification)
    if (mounted) {
      final gamificationProvider = Provider.of<GamificationProvider>(
        context,
        listen: false
      );
      gamificationProvider.awardPoints(5); // 5 XP per question
    }

  } catch (e) {
    print('❌ Error getting response: $e');
    
    setState(() {
      _isLoading = false;
      _messages.add({
        'text': 'Sorry, I encountered an error. Please try again.',
        'isUser': false,
        'time': DateTime.now(),
        'isError': true,
      });
    });
    
    _scrollToBottom();
  }
}
  void _clearChat() {
    setState(() {
      _messages.clear();
      _addWelcomeMessage();
    });
  }
void _selectSubject(String subject) {
  setState(() {
    _currentSubject = subject.toLowerCase();
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIKHYA SETU'),
        backgroundColor: const Color(0xFF4A90E2),
        actions: [
          // Subject selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.book, color: Colors.white),
            onSelected: _selectSubject,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'general',
                child: Text('General'),
              ),
              const PopupMenuItem(
                value: 'math',
                child: Text('📐 Mathematics'),
              ),
              const PopupMenuItem(
                value: 'science',
                child: Text('🔬 Science'),
              ),
              const PopupMenuItem(
                value: 'physics',
                child: Text('⚡ Physics'),
              ),
              const PopupMenuItem(
                value: 'chemistry',
                child: Text('🧪 Chemistry'),
              ),
              const PopupMenuItem(
                value: 'biology',
                child: Text('🧬 Biology'),
              ),
            ],
          ),
          // Clear chat button
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _clearChat,
            tooltip: 'Clear chat',
          ),
          // Local mode indicator
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.offline_bolt, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text(
                  'Offline',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Consumer<GamificationProvider>(
        builder: (context, gamificationProvider, _) {
          return Column(
            children: [
              // Gamification Header
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.blue[50],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.stars,
                      value: 'Lvl ${gamificationProvider.playerLevel.level}',
                      label: gamificationProvider.playerLevel.title,
                      onTap: () => _selectSubject('general'),
                    ),
                    _buildStatItem(
                      icon: Icons.local_fire_department,
                      value: '${gamificationProvider.studyStreak.currentStreak}',
                      label: 'Day Streak',
                      iconColor: Colors.red,
                      onTap: () => _selectSubject('math'),
                    ),
                    _buildStatItem(
                      icon: Icons.bolt,
                      value: '${gamificationProvider.playerLevel.totalExperience}',
                      label: 'XP',
                      onTap: () => _selectSubject('science'),
                    ),
                  ],
                ),
              ),
              
              // Current subject indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: _getSubjectColor().withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(color: _getSubjectColor().withOpacity(0.3)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(_getSubjectIcon(), color: _getSubjectColor(), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Current subject: ${_currentSubject.toUpperCase()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getSubjectColor(),
                        ),
                      ),
                    ),
                    if (_isLoading)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _getSubjectColor(),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Chat Area
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isLastMessage = index == _messages.length - 1;

                    return AnimatedOpacity(
                      duration: Duration(milliseconds: isLastMessage ? 300 : 0),
                      opacity: 1.0,
                      child: ChatBubble(
                        message: message['text'],
                        isUser: message['isUser'],
                        time: message['time'],
                        isSystem: message['isSystem'] == true,
                        isError: message['isError'] == true,
                      ),
                    );
                  },
                ),
              ),
              
              // Quick question chips
              _buildQuickQuestionChips(),
              
              // Input Area
              _buildInputArea(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    Color iconColor = Colors.blue,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQuestionChips() {
    final mathQuestions = ['2+2?', 'Pythagoras theorem', 'What is algebra?', 'Solve for x: 2x+5=15'];
    final scienceQuestions = ['What is gravity?', 'Photosynthesis', 'Newton\'s laws', 'What is a cell?'];
    
    final questions = _currentSubject == 'math' ? mathQuestions : 
                     _currentSubject == 'science' ? scienceQuestions : 
                     [...mathQuestions, ...scienceQuestions].take(4).toList();

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(questions[index]),
              onPressed: () {
                _messageController.text = questions[index];
                _sendMessage();
              },
              backgroundColor: _getSubjectColor().withOpacity(0.1),
              labelStyle: TextStyle(
                color: _getSubjectColor(),
                fontSize: 12,
              ),
              side: BorderSide(color: _getSubjectColor().withOpacity(0.3)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.grey.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask me anything about $_currentSubject...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                suffixIcon: _messageController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => _messageController.clear(),
                      )
                    : null,
              ),
              onSubmitted: (_) => _sendMessage(),
              enabled: !_isLoading,
              maxLines: null,
              textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: _isLoading ? null : _sendMessage,
            backgroundColor: _isLoading ? Colors.grey : _getSubjectColor(),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Color _getSubjectColor() {
    switch (_currentSubject) {
      case 'math':
      case 'mathematics':
        return Colors.blue;
      case 'science':
        return Colors.green;
      case 'physics':
        return Colors.orange;
      case 'chemistry':
        return Colors.purple;
      case 'biology':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getSubjectIcon() {
    switch (_currentSubject) {
      case 'math':
      case 'mathematics':
        return Icons.calculate;
      case 'science':
        return Icons.science;
      case 'physics':
        return Icons.bolt;
      case 'chemistry':
        return Icons.science_outlined;
      case 'biology':
        return Icons.biotech;
      default:
        return Icons.chat;
    }
  }

  Color _getSubjectTextColor() {
    return _getSubjectColor();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
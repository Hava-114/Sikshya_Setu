import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_tutor_provider.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/connectivity_indicator.dart';

class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({Key? key}) : super(key: key);

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  late AiTutorProvider _tutorProvider;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedTopic;

  @override
  void initState() {
    super.initState();
    _tutorProvider = Provider.of<AiTutorProvider>(context, listen: false);
    _tutorProvider.initialize();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AiTutorProvider, ConnectivityProvider>(
      builder: (context, tutorProvider, connectivityProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('AI Tutor'),
            elevation: 0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: ConnectivityIndicator(showLabel: true),
              ),
            ],
          ),
          body: _selectedTopic == null
              ? _buildTopicSelection(tutorProvider)
              : _buildChatInterface(tutorProvider),
        );
      },
    );
  }

  Widget _buildTopicSelection(AiTutorProvider tutorProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          tutorProvider.isOllamaAvailable
                              ? Icons.check_circle
                              : Icons.error_outline,
                          color: tutorProvider.isOllamaAvailable
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tutorProvider.isOllamaAvailable
                                ? 'AI Tutor Ready'
                                : 'AI Tutor Initializing...',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tutorProvider.isOllamaAvailable
                          ? 'Phi-3 AI model is ready. Choose a topic to get started!'
                          : 'Make sure Ollama + FastAPI is running on http://172.16.45.152:8000',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select a Topic',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: tutorProvider.availableTopics.length,
              itemBuilder: (context, index) {
                final topic = tutorProvider.availableTopics[index];
                return _buildTopicCard(topic, tutorProvider);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(String topic, AiTutorProvider tutorProvider) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTopic = topic;
          });
          tutorProvider.setTopic(topic);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getTopicIcon(topic),
                size: 32,
                color: Colors.blue.shade600,
              ),
              const SizedBox(height: 8),
              Text(
                topic,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTopicIcon(String topic) {
    if (topic.contains('Mathematics')) return Icons.calculate;
    if (topic.contains('Physics')) return Icons.science;
    if (topic.contains('Chemistry')) return Icons.local_fire_department;
    if (topic.contains('Biology')) return Icons.biotech;
    if (topic.contains('History')) return Icons.history_edu;
    if (topic.contains('Geography')) return Icons.public;
    if (topic.contains('Literature')) return Icons.auto_stories;
    if (topic.contains('Science')) return Icons.science;
    return Icons.lightbulb;
  }

  Widget _buildChatInterface(AiTutorProvider tutorProvider) {
    return Column(
      children: [
        // Topic header with back button
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue.shade50,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedTopic = null;
                  });
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chatting about',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      _selectedTopic!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      tutorProvider.clearChatHistory();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.delete, size: 20),
                        SizedBox(width: 8),
                        Text('Clear History'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Chat messages
        Expanded(
          child: tutorProvider.chatHistory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Start a conversation',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ask any question about $_selectedTopic',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount: tutorProvider.chatHistory.length,
                  itemBuilder: (context, index) {
                    final message = tutorProvider.chatHistory[index];
                    return _buildMessageBubble(message);
                  },
                ),
        ),
        // Error display
        if (tutorProvider.error != null)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.red.shade50,
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tutorProvider.error!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        // Input field
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ask a question...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  enabled: !tutorProvider.isLoading,
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                onPressed: tutorProvider.isLoading
                    ? null
                    : () {
                        final message = _messageController.text.trim();
                        if (message.isNotEmpty) {
                          tutorProvider.sendMessage(message);
                          _messageController.clear();
                          _scrollToBottom();
                        }
                      },
                child: tutorProvider.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.role == 'user';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isUser ? Colors.blue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            message.content,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

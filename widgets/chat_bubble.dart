// widgets/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime time;
  final bool isSystem;
  final bool isError;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.time,
    this.isSystem = false,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: _getAvatarColor(),
                child: Icon(_getIcon(), color: Colors.white, size: 16),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getBubbleColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.jm().format(time),
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green,
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
            ),
        ],
      ),
    );
  }

  Color _getBubbleColor() {
    if (isUser) return Colors.blue[100]!;
    if (isError) return Colors.red[100]!;
    if (isSystem) return Colors.orange[100]!;
    return Colors.grey[200]!;
  }

  Color _getAvatarColor() {
    if (isError) return Colors.red;
    if (isSystem) return Colors.orange;
    return Colors.blue;
  }

  IconData _getIcon() {
    if (isError) return Icons.error;
    if (isSystem) return Icons.info;
    return Icons.smart_toy;
  }
}
import 'package:uuid/uuid.dart';

enum MessageRole { user, assistant, system }

class Message {
  final String id;
  final MessageRole role;
  final String content;
  final DateTime timestamp;
  final bool isError;

  Message({
    String? id,
    required this.role,
    required this.content,
    DateTime? timestamp,
    this.isError = false,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'isError': isError,
      };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        role: MessageRole.values.firstWhere((e) => e.name == json['role']),
        content: json['content'],
        timestamp: DateTime.parse(json['timestamp']),
        isError: json['isError'] ?? false,
      );
}

// ... keep the existing Message class ...

class Conversation {
  final String id;
  String title;
  final List<Message> messages;
  final DateTime createdAt;
  DateTime updatedAt;

  Conversation({
    String? id,
    this.title = 'New Chat',
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        messages = messages ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'messages': messages.map((m) => m.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json['id'],
        title: json['title'] ?? 'New Chat',
        messages: (json['messages'] as List)
            .map((m) => Message.fromJson(m))
            .toList(),
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}
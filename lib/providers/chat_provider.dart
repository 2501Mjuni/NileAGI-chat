import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../services/ollama_service.dart';

class ChatProvider extends ChangeNotifier {
  final List<Conversation> _conversations = [];
  String? _currentConversationId;
  bool _isLoading = false;
  String? _error;

  String _baseUrl = 'http://localhost:11434/v1';
  String _model = 'gemma4:e4b';

  late OllamaService _service;

  ChatProvider() {
    _service = OllamaService(baseUrl: _baseUrl, model: _model);
    _loadData();
  }

  // ── Getters ──────────────────────────────────────────────
  List<Conversation> get conversations =>
      List.unmodifiable(_conversations.reversed.toList()); // newest first

  Conversation? get currentConversation {
    if (_currentConversationId == null) return null;
    try {
      return _conversations
          .firstWhere((c) => c.id == _currentConversationId);
    } catch (_) {
      return null;
    }
  }

  List<Message> get messages =>
      currentConversation?.messages ?? [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  String get baseUrl => _baseUrl;
  String get model => _model;

  // ── Load / Save ──────────────────────────────────────────
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    _baseUrl = prefs.getString('baseUrl') ?? 'http://localhost:11434/v1';
    _model = prefs.getString('model') ?? 'gemma4:e4b';
    _service = OllamaService(baseUrl: _baseUrl, model: _model);

    final raw = prefs.getString('conversations');
    if (raw != null) {
      final List list = jsonDecode(raw);
      _conversations.clear();
      _conversations.addAll(
        list.map((e) => Conversation.fromJson(e)).toList(),
      );
    }

    _currentConversationId = prefs.getString('currentConversationId');

    // If nothing exists, create the first chat
    if (_conversations.isEmpty) {
      _createNewConversation(save: false);
    } else if (_currentConversationId == null ||
        !_conversations.any((c) => c.id == _currentConversationId)) {
      _currentConversationId = _conversations.last.id;
    }

    notifyListeners();
  }

  Future<void> _saveConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_conversations.map((c) => c.toJson()).toList());
    await prefs.setString('conversations', raw);
    if (_currentConversationId != null) {
      await prefs.setString('currentConversationId', _currentConversationId!);
    }
  }

  // ── Conversation management ──────────────────────────────
  void _createNewConversation({bool save = true}) {
    final conv = Conversation();
    _conversations.add(conv);
    _currentConversationId = conv.id;
    if (save) _saveConversations();
    notifyListeners();
  }

  void newChat() {
    _createNewConversation();
  }

  void switchConversation(String id) {
    if (_currentConversationId == id) return;
    _currentConversationId = id;
    _saveConversations();
    notifyListeners();
  }

  void deleteConversation(String id) {
    _conversations.removeWhere((c) => c.id == id);
    if (_currentConversationId == id) {
      if (_conversations.isNotEmpty) {
        _currentConversationId = _conversations.last.id;
      } else {
        _createNewConversation(save: false);
      }
    }
    _saveConversations();
    notifyListeners();
  }

  // ── Settings ─────────────────────────────────────────────
  Future<void> updateSettings({
    required String baseUrl,
    required String model,
  }) async {
    _baseUrl = baseUrl.trim();
    _model = model.trim();
    _service = OllamaService(baseUrl: _baseUrl, model: _model);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseUrl', _baseUrl);
    await prefs.setString('model', _model);
    notifyListeners();
  }

  // ── Send message ─────────────────────────────────────────
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    var conv = currentConversation;
    if (conv == null) {
      _createNewConversation(save: false);
      conv = currentConversation!;
    }

    _error = null;
    final userMessage = Message(role: MessageRole.user, content: text.trim());
    conv.messages.add(userMessage);

    // Auto-title from first message
    if (conv.messages.length == 1) {
      conv.title = text.trim().length > 40
          ? '${text.trim().substring(0, 40)}...'
          : text.trim();
    }

    conv.updatedAt = DateTime.now();
    _isLoading = true;
    notifyListeners();

    try {
      final reply = await _service.chat(conv.messages);
      conv.messages.add(
        Message(role: MessageRole.assistant, content: reply.trim()),
      );
    } catch (e) {
      _error = e.toString();
      conv.messages.add(Message(
        role: MessageRole.assistant,
        content: 'Error: ${e.toString()}',
        isError: true,
      ));
    } finally {
      _isLoading = false;
      conv.updatedAt = DateTime.now();
      await _saveConversations();
      notifyListeners();
    }
  }

  void clearCurrentChat() {
    final conv = currentConversation;
    if (conv == null) return;
    conv.messages.clear();
    conv.title = 'New Chat';
    _saveConversations();
    notifyListeners();
  }
}
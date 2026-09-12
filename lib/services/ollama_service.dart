import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class OllamaService {
  String baseUrl;
  String model;

  OllamaService({
    this.baseUrl = 'http://localhost:11434/v1',
    this.model = 'gemma4:e4b',
  });

  Future<String> chat(List<Message> messages) async {
    final url = Uri.parse('$baseUrl/chat/completions');

    final body = {
      'model': model,
      'messages': messages
          .where((m) => m.role != MessageRole.system || m.content.isNotEmpty)
          .map((m) => {
                'role': m.role.name,
                'content': m.content,
              })
          .toList(),
      'stream': false,
      'temperature': 0.7,
    };

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            // Ollama usually doesn't need a real key
            'Authorization': 'Bearer ollama',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(minutes: 3));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] as String;
    } else {
      throw Exception(
        'Ollama error ${response.statusCode}: ${response.body}',
      );
    }
  }

  Future<bool> checkConnection() async {
    try {
      final url = Uri.parse('$baseUrl/models');
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
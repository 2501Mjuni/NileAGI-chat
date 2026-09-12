import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _baseUrlController;
  late TextEditingController _modelController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ChatProvider>();
    _baseUrlController = TextEditingController(text: provider.baseUrl);
    _modelController = TextEditingController(text: provider.model);
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Inference Server',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _baseUrlController,
            decoration: const InputDecoration(
              labelText: 'Base URL',
              hintText: 'http://localhost:11434/v1',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _modelController,
            decoration: const InputDecoration(
              labelText: 'Model Name',
              hintText: 'gemma4:e4b',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton(
            onPressed: () async {
              await context.read<ChatProvider>().updateSettings(
                    baseUrl: _baseUrlController.text,
                    model: _modelController.text,
                  );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings saved')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save Settings'),
          ),
          const SizedBox(height: 12),
         OutlinedButton(
  onPressed: () {
    context.read<ChatProvider>().clearCurrentChat();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Current chat cleared')),
    );
  },
  child: const Text('Clear Current Chat'),
),
        ],
      ),
    );
  }
}
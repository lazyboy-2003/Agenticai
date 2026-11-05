import 'package:flutter/material.dart';
import '../services/gemini_service.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});
  @override State<AISettingsScreen> createState() => _AISettingsScreenState();
}
class _AISettingsScreenState extends State<AISettingsScreen> {
  final key = TextEditingController();
  bool checking = false, saved = false;
  String status = '';
  @override void dispose() { key.dispose(); super.dispose(); }

  Future<void> save() async {
    if (key.text.trim().isEmpty) return;
    setState(() { checking = true; status = ''; });
    try {
      await GeminiService.saveApiKey(key.text);
      final answer = await GeminiService.ask(input: 'Reply with exactly: Connection successful.');
      if (!mounted) return;
      setState(() { saved = true; status = answer; });
    } catch (e) {
      if (!mounted) return;
      setState(() { saved = false; status = e.toString(); });
    } finally {
      if (mounted) setState(() => checking = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Online AI Setup')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Icon(Icons.cloud_done_rounded, size: 48),
      const SizedBox(height: 12),
      const Text('Connect AgenticAI Online', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      const Text('AgenticAI uses Gemini for online mentoring and Google Search grounding for fresh web information. Internet and your own Gemini API key are required. API usage may be subject to Google quotas and pricing.'),
      const SizedBox(height: 16),
      const Text('Get a key from Google AI Studio: aistudio.google.com/app/apikey'),
      const SizedBox(height: 16),
      TextField(controller: key, obscureText: true, autocorrect: false, enableSuggestions: false,
        decoration: const InputDecoration(labelText: 'Gemini API key', hintText: 'Paste your Gemini key', border: OutlineInputBorder())),
      const SizedBox(height: 12),
      FilledButton.icon(onPressed: checking ? null : save,
        icon: checking ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.cloud_sync_rounded),
        label: Text(checking ? 'Checking connection...' : 'Save & test connection')),
      if (status.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 14),
        child: SelectableText(status, style: TextStyle(color: saved ? Colors.green : Theme.of(context).colorScheme.error))),
      const SizedBox(height: 16),
      const Text('Security: this starter app stores the key locally on this device. Never publish a shared key in the APK or GitHub. For a public production release, move API calls behind a secure backend.'),
    ]),
  );
}

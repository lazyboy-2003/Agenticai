import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/gemini_service.dart';
import 'ai_settings_screen.dart';

class CurrentAffairsScreen extends StatefulWidget {
  const CurrentAffairsScreen({super.key});
  @override State<CurrentAffairsScreen> createState() => _CurrentAffairsScreenState();
}
class _CurrentAffairsScreenState extends State<CurrentAffairsScreen> {
  String text = '', category = 'All';
  bool loading = false;
  final cats = ['All', 'India', 'World', 'Economy', 'Science', 'Sports', 'Awards'];

  Future<void> refresh() async {
    if (!await GeminiService.configured()) {
      if (mounted) await Navigator.push(context, MaterialPageRoute(builder: (_) => const AISettingsScreen()));
      return;
    }
    setState(() => loading = true);
    try {
      final now = DateTime.now();
      final prompt = 'Today is ${now.toIso8601String().substring(0, 10)}. Search the live web and prepare 10 verified, exam-focused ${category == 'All' ? 'India, World, Economy, Science, Sports and Awards' : category} current-affairs updates for Indian SSC CGL, SSC CHSL, RRB NTPC, Banking and State PSC aspirants. Prioritise the latest 7 days, include exact event dates, explain why each matters, and add one likely MCQ fact per item. Use reliable official sources wherever possible. Clearly mark older background items. Never fabricate events, dates, statistics or sources.';
      final answer = await GeminiService.ask(input: prompt, webSearch: true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('latest_current_affairs', answer);
      await prefs.setString('latest_current_affairs_date', now.toIso8601String());
      if (mounted) setState(() => text = answer);
    } catch (e) {
      if (mounted) setState(() => text = 'Could not load live current affairs. Check internet/API quota and retry.\n\n$e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('latest_current_affairs');
    if (saved != null && mounted) setState(() => text = saved);
  }
  @override void initState() { super.initState(); loadSaved(); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Live Current Affairs'),
      actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AISettingsScreen())), icon: const Icon(Icons.settings_rounded))]),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Live web-grounded exam updates', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
      const SizedBox(height: 6),
      const Text('Uses Gemini with Google Search grounding. Check the source links shown with each response.'),
      const SizedBox(height: 14),
      Wrap(spacing: 8, runSpacing: 8, children: cats.map((item) => ChoiceChip(label: Text(item), selected: category == item, onSelected: (_) => setState(() => category = item))).toList()),
      const SizedBox(height: 14),
      FilledButton.icon(onPressed: loading ? null : refresh, icon: const Icon(Icons.travel_explore_rounded), label: Text(loading ? 'Searching the web...' : 'Fetch latest updates')),
      if (loading) const Padding(padding: EdgeInsets.only(top: 16), child: LinearProgressIndicator()),
      if (text.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 18), child: SelectableText(text, style: const TextStyle(height: 1.55))),
    ]),
  );
}

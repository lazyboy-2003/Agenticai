import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GeminiService {
  static const _model = 'gemini-3.5-flash';
  static const _endpoint = 'https://generativelanguage.googleapis.com/v1beta/models/';

  static Future<String?> apiKey() async => (await SharedPreferences.getInstance()).getString('gemini_api_key');
  static Future<void> saveApiKey(String key) async => (await SharedPreferences.getInstance()).setString('gemini_api_key', key.trim());
  static Future<bool> configured() async => ((await apiKey()) ?? '').isNotEmpty;

  static Future<String> ask({required String input, bool webSearch = false}) async {
    final key = await apiKey();
    if (key == null || key.isEmpty) throw Exception('Gemini API key not configured. Open Online AI Setup.');

    final body = <String, dynamic>{
      'systemInstruction': {'parts': [{'text': 'You are AgenticAI, an online autonomous study and career mentor for Indian government-job aspirants. Help with SSC CGL, SSC CHSL, RRB NTPC, Banking and State PSC. Understand the goal, analyse student context, make practical plans and give clear next actions. Reply in the requested language. Never invent exam notifications, dates, cutoffs, answer keys or current affairs.'}]},
      'contents': [{'role': 'user', 'parts': [{'text': input}]}],
      'generationConfig': {'temperature': webSearch ? 1.0 : 0.45, 'maxOutputTokens': 1800},
    };
    if (webSearch) body['tools'] = [{'google_search': {}}];

    final uri = Uri.parse('$_endpoint$_model:generateContent');
    final response = await http.post(uri,
      headers: {'x-goog-api-key': key, 'Content-Type': 'application/json'},
      body: jsonEncode(body)).timeout(const Duration(seconds: 60));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      var detail = response.body;
      try {
        final decoded = jsonDecode(response.body);
        detail = decoded['error']?['message']?.toString() ?? detail;
      } catch (_) {}
      if (response.statusCode == 429) throw Exception('Gemini quota/rate limit reached. Wait and retry. $detail');
      throw Exception('Gemini request failed (${response.statusCode}): $detail');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List? ?? const [];
    final texts = <String>[];
    final sources = <String>[];
    for (final candidate in candidates) {
      if (candidate is! Map) continue;
      final content = candidate['content'];
      if (content is Map) {
        for (final part in (content['parts'] as List? ?? const [])) {
          if (part is Map && part['text'] is String) texts.add(part['text'] as String);
        }
      }
      final metadata = candidate['groundingMetadata'];
      if (metadata is Map) {
        for (final chunk in (metadata['groundingChunks'] as List? ?? const [])) {
          if (chunk is Map && chunk['web'] is Map) {
            final web = chunk['web'] as Map;
            final title = web['title']?.toString() ?? 'Web source';
            final url = web['uri']?.toString();
            if (url != null && url.startsWith('http')) {
              final line = '- $title: $url';
              if (!sources.contains(line)) sources.add(line);
            }
          }
        }
      }
    }
    if (texts.isEmpty) throw Exception('Gemini returned no answer. Please try again.');
    final answer = texts.join('\n').trim();
    if (webSearch && sources.isNotEmpty) return '$answer\n\nSources:\n${sources.take(6).join('\n')}';
    return answer;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OpenAIService {
  static const _url='https://api.openai.com/v1/responses';
  static Future<String?> apiKey() async => (await SharedPreferences.getInstance()).getString('openai_api_key');
  static Future<void> saveApiKey(String key) async => (await SharedPreferences.getInstance()).setString('openai_api_key',key.trim());
  static Future<bool> configured() async => ((await apiKey())??'').isNotEmpty;

  static Future<String> ask({required String input,bool webSearch=false}) async {
    final key=await apiKey();
    if(key==null||key.isEmpty) throw Exception('API key not configured');
    final body=<String,dynamic>{
      'model':'gpt-6-luna',
      'instructions':'You are AgenticAI V2, an exam mentor for Indian government-job aspirants. Be accurate, practical and concise. Reply in the language requested by the user. Never invent current affairs; when web search is enabled, use fresh web information.',
      'input':input,
      'max_output_tokens':900,
      if(webSearch)'tools':[{'type':'web_search'}],
    };
    final res=await http.post(Uri.parse(_url),headers:{'Authorization':'Bearer $key','Content-Type':'application/json'},body:jsonEncode(body)).timeout(const Duration(seconds:45));
    if(res.statusCode<200||res.statusCode>=300) throw Exception('OpenAI error '+res.statusCode.toString()+': '+res.body);
    final data=jsonDecode(res.body) as Map<String,dynamic>;
    final direct=data['output_text'];
    if(direct is String&&direct.trim().isNotEmpty)return direct.trim();
    final out=data['output'] as List? ?? const [];
    final texts=<String>[];
    for(final item in out){if(item is Map&&item['content'] is List){for(final c in item['content']){if(c is Map&&c['text'] is String)texts.add(c['text']);}}}
    if(texts.isEmpty)throw Exception('No text returned');
    return texts.join('\n').trim();
  }
}

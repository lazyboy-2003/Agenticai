import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class GeminiService {
 static const _model='gemini-3.5-flash';
 static Future<String?> apiKey() async=>(await SharedPreferences.getInstance()).getString('gemini_api_key');
 static Future<void> saveApiKey(String key) async=>(await SharedPreferences.getInstance()).setString('gemini_api_key',key.trim());
 static Future<bool> configured() async=>((await apiKey())??'').isNotEmpty;
 static Future<String> ask({required String input,bool webSearch=false})async{
  final key=await apiKey();if(key==null||key.isEmpty)throw Exception('Gemini API key not configured');
  final uri=Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/'+_model+':generateContent');
  final body={'systemInstruction':{'parts':[{'text':'You are AgenticAI V2, an accurate and practical mentor for Indian government-job aspirants. Reply in the student preferred language.'}]},'contents':[{'role':'user','parts':[{'text':input}]}],'generationConfig':{'temperature':0.35,'maxOutputTokens':1000}};
  final r=await http.post(uri,headers:{'x-goog-api-key':key,'Content-Type':'application/json'},body:jsonEncode(body)).timeout(const Duration(seconds:45));
  if(r.statusCode<200||r.statusCode>=300)throw Exception('Gemini error '+r.statusCode.toString()+': '+r.body);
  final d=jsonDecode(r.body) as Map<String,dynamic>;final texts=<String>[];
  for(final c in (d['candidates'] as List? ?? const [])){if(c is Map&&c['content'] is Map){for(final p in ((c['content'] as Map)['parts'] as List? ?? const [])){if(p is Map&&p['text'] is String)texts.add(p['text']);}}}
  if(texts.isEmpty)throw Exception('Gemini returned no text');return texts.join('\n').trim();
 }
}

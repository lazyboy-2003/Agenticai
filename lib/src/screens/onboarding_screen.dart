import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});
  @override State<OnboardingScreen> createState() => _OnboardingScreenState();
}
class _OnboardingScreenState extends State<OnboardingScreen> {
  final name = TextEditingController();
  String exam='SSC CGL', language='Bengali';
  double hours=3;
  DateTime? targetDate;
  final Set<String> weak={};
  static const exams=['SSC CGL','SSC CHSL','RRB NTPC','Banking','State PSC'];
  static const subjects=['Math','Reasoning','English','GK/GS','Current Affairs'];

  Future<void> save() async {
    final p=await SharedPreferences.getInstance();
    await p.setBool('onboarding_done',true);
    await p.setString('name',name.text.trim());
    await p.setString('exam',exam);
    await p.setString('language',language);
    await p.setDouble('daily_hours',hours);
    await p.setStringList('weak_subjects',weak.toList());
    if(targetDate!=null) await p.setString('target_date',targetDate!.toIso8601String());
    widget.onComplete();
  }
  @override void dispose(){name.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:ListView(padding:const EdgeInsets.all(24),children:[
    const SizedBox(height:16),
    Text('Build your preparation profile',style:Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight:FontWeight.w800)),
    const SizedBox(height:8),const Text('AgenticAI will personalise your study plan and advice.'),
    const SizedBox(height:28),
    TextField(controller:name,decoration:const InputDecoration(labelText:'Your name',border:OutlineInputBorder())),
    const SizedBox(height:18),
    DropdownButtonFormField<String>(value:exam,decoration:const InputDecoration(labelText:'Target exam',border:OutlineInputBorder()),items:exams.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:(v)=>setState(()=>exam=v!)),
    const SizedBox(height:22),
    Text('Daily study time: '+hours.toStringAsFixed(1)+' hours',style:const TextStyle(fontWeight:FontWeight.w700)),
    Slider(value:hours,min:1,max:10,divisions:18,onChanged:(v)=>setState(()=>hours=v)),
    OutlinedButton.icon(icon:const Icon(Icons.event),label:Text(targetDate==null?'Choose target exam date':'Target date selected'),onPressed:()async{final d=await showDatePicker(context:context,firstDate:DateTime.now(),lastDate:DateTime.now().add(const Duration(days:1095)));if(d!=null)setState(()=>targetDate=d);}),
    const SizedBox(height:20),
    Text('Weak subjects',style:Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight:FontWeight.bold)),
    Wrap(spacing:8,children:subjects.map((s)=>FilterChip(label:Text(s),selected:weak.contains(s),onSelected:(x)=>setState(()=>x?weak.add(s):weak.remove(s)))).toList()),
    const SizedBox(height:20),
    SegmentedButton<String>(segments:const [ButtonSegment(value:'Bengali',label:Text('বাংলা')),ButtonSegment(value:'English',label:Text('English'))],selected:{language},onSelectionChanged:(v)=>setState(()=>language=v.first)),
    const SizedBox(height:30),
    FilledButton.icon(onPressed:save,icon:const Icon(Icons.arrow_forward),label:const Text('Create my preparation profile')),
  ])));
}
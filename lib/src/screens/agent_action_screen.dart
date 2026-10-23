import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/agentic_brain.dart';
class AgentActionScreen extends StatefulWidget{const AgentActionScreen({super.key});@override State<AgentActionScreen> createState()=>_AgentActionScreenState();}
class _AgentActionScreenState extends State<AgentActionScreen>{
 AgentDecision? d;String exam='Exam';int daysLeft=30;
 @override void initState(){super.initState();load();}
 Future<void> load()async{final p=await SharedPreferences.getInstance();exam=p.getString('exam')??'Exam';final c=p.getInt('last_mock_correct')??0,t=p.getInt('last_mock_total')??0,done=(p.getStringList('completed_topics')??[]).length;final acc=t==0?0:(c/t*100).round();final weak=p.getStringList('weak_subjects')??[];final h=p.getDouble('daily_hours')??3;final raw=p.getString('target_date');if(raw!=null){final date=DateTime.tryParse(raw);if(date!=null)daysLeft=date.difference(DateTime.now()).inDays.clamp(0,9999);}d=AgenticBrain.decide(accuracy:acc,mockTotal:t,completedTopics:done,weak:weak,hours:h,daysLeft:daysLeft);if(mounted)setState((){});}
 @override Widget build(BuildContext context){if(d==null)return const Scaffold(body:Center(child:CircularProgressIndicator()));return Scaffold(appBar:AppBar(title:const Text('Agentic Brain')),body:ListView(padding:const EdgeInsets.all(20),children:[
  Text('Your next best action',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800)),Text(exam+' • '+daysLeft.toString()+' days left'),const SizedBox(height:20),
  Card(child:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Icon(Icons.psychology_alt_rounded,size:38),const SizedBox(height:12),Text(d!.title,style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w800)),const SizedBox(height:10),Text(d!.reason),const Divider(height:28),const Text('Do this now',style:TextStyle(fontWeight:FontWeight.w700)),const SizedBox(height:6),Text(d!.action)]))),
  const SizedBox(height:14),FilledButton.icon(onPressed:load,icon:const Icon(Icons.refresh_rounded),label:const Text('Recalculate from latest performance')),
  const SizedBox(height:12),const Text('Decision inputs: mock accuracy, syllabus progress, weak subjects and days remaining. More signals will be added as the app grows.')
 ]));}
}

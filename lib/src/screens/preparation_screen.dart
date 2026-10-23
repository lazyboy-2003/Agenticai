import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/exam_preparation_engine.dart';
class PreparationScreen extends StatefulWidget{const PreparationScreen({super.key});@override State<PreparationScreen> createState()=>_PreparationScreenState();}
class _PreparationScreenState extends State<PreparationScreen>{
 String exam='Exam',filter='All';List<ExamTopic> topics=[];Set<String> completed={};
 @override void initState(){super.initState();load();}
 Future<void> load()async{final p=await SharedPreferences.getInstance();exam=p.getString('exam')??'SSC CGL';completed=(p.getStringList('completed_topics')??[]).toSet();topics=ExamPreparationEngine.topicsFor(exam);if(mounted)setState((){});}
 Future<void> toggle(ExamTopic t,bool? v)async{final key=t.subject+'|'+t.chapter;setState(()=>(v??false)?completed.add(key):completed.remove(key));final p=await SharedPreferences.getInstance();await p.setStringList('completed_topics',completed.toList());}
 @override Widget build(BuildContext context){final subjects=['All',...{...topics.map((e)=>e.subject)}];final shown=filter=='All'?topics:topics.where((e)=>e.subject==filter).toList();final done=topics.where((t)=>completed.contains(t.subject+'|'+t.chapter)).length;return ListView(padding:const EdgeInsets.all(20),children:[
 Text('Exam Preparation',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800)),Text(exam+' syllabus engine'),const SizedBox(height:16),
 Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Syllabus progress: '+done.toString()+'/'+topics.length.toString(),style:const TextStyle(fontWeight:FontWeight.w700)),const SizedBox(height:10),LinearProgressIndicator(value:topics.isEmpty?0:done/topics.length)]))),const SizedBox(height:14),
 SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(children:subjects.map((s)=>Padding(padding:const EdgeInsets.only(right:8),child:ChoiceChip(label:Text(s),selected:filter==s,onSelected:(_)=>setState(()=>filter=s)))).toList())),const SizedBox(height:14),
 ...shown.map((t){final key=t.subject+'|'+t.chapter;return Card(child:CheckboxListTile(value:completed.contains(key),onChanged:(v)=>toggle(t,v),title:Text(t.chapter,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text(t.subject+' • '+t.priority+' priority'),secondary:Icon(t.priority=='High'?Icons.local_fire_department_rounded:Icons.menu_book_rounded)));})
 ]);}
}

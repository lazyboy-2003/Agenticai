import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressScreen extends StatefulWidget{const ProgressScreen({super.key});@override State<ProgressScreen> createState()=>_ProgressScreenState();}
class _ProgressScreenState extends State<ProgressScreen>{
 int correct=0,total=0,completedTopics=0;double score=0;List<String> weak=[];bool loading=true;
 @override void initState(){super.initState();load();}
 Future<void> load()async{final p=await SharedPreferences.getInstance();correct=p.getInt('last_mock_correct')??0;total=p.getInt('last_mock_total')??0;score=p.getDouble('last_mock_score')??0;weak=p.getStringList('weak_subjects')??[];completedTopics=(p.getStringList('completed_topics')??[]).length;if(mounted)setState(()=>loading=false);}
 int get accuracy=>total==0?0:(correct/total*100).round();
 int get readiness{final mockPart=total==0?0:accuracy;final syllabusPart=(completedTopics*4).clamp(0,100);return ((mockPart*.65)+(syllabusPart*.35)).round().clamp(0,100);}
 String get advice{if(total==0)return 'Take your first mock test. Your mentor needs performance data to adapt your plan.';if(accuracy<60)return 'Accuracy is the priority. Slow down, review mistakes, then retry weak chapters.';if(accuracy<80)return 'Good base. Increase timed PYQ practice and revise '+(weak.isEmpty?'your weakest subject':weak.first)+'.';return 'Strong accuracy. Shift toward speed, full mocks and spaced revision.';}
 @override Widget build(BuildContext context){if(loading)return const Center(child:CircularProgressIndicator());return RefreshIndicator(onRefresh:load,child:ListView(padding:const EdgeInsets.all(20),children:[
 Text('Performance Intelligence',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800)),const SizedBox(height:4),const Text('Your preparation signals in one place'),const SizedBox(height:20),
 Row(children:[Expanded(child:_Metric('Readiness',readiness.toString()+'%',Icons.speed_rounded)),const SizedBox(width:10),Expanded(child:_Metric('Accuracy',accuracy.toString()+'%',Icons.gps_fixed_rounded))]),const SizedBox(height:10),
 Row(children:[Expanded(child:_Metric('Last score',score.toStringAsFixed(2),Icons.quiz_rounded)),const SizedBox(width:10),Expanded(child:_Metric('Topics done',completedTopics.toString(),Icons.task_alt_rounded))]),const SizedBox(height:18),
 Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('AI Next Action',style:TextStyle(fontWeight:FontWeight.w800,fontSize:17)),const SizedBox(height:8),Text(advice)]))),const SizedBox(height:18),
 Text('Priority weaknesses',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w800)),const SizedBox(height:10),
 if(weak.isEmpty)const Card(child:ListTile(title:Text('No weak subjects selected'),subtitle:Text('Complete onboarding or use mock results to identify weaknesses.')))
 else ...weak.map((w)=>Card(child:ListTile(leading:const Icon(Icons.warning_amber_rounded),title:Text(w),subtitle:const Text('Prioritise concepts → PYQ → timed practice → revision')))),
 const SizedBox(height:18),Text('Mistake Book',style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w800)),const SizedBox(height:8),
 Card(child:ListTile(leading:const Icon(Icons.menu_book_rounded),title:Text(total==0?'No mock mistakes yet':(total-correct).toString()+' questions need review'),subtitle:const Text('Incorrect and skipped questions become revision targets automatically.'),trailing:const Icon(Icons.chevron_right_rounded)))
 ]));}
}
class _Metric extends StatelessWidget{final String label,value;final IconData icon;const _Metric(this.label,this.value,this.icon);@override Widget build(BuildContext context)=>Card(child:Padding(padding:const EdgeInsets.all(16),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Icon(icon),const SizedBox(height:10),Text(value,style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w800)),Text(label)])));}

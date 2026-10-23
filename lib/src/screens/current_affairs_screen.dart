import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentAffairsScreen extends StatefulWidget{const CurrentAffairsScreen({super.key});@override State<CurrentAffairsScreen> createState()=>_CurrentAffairsScreenState();}
class _CurrentAffairsScreenState extends State<CurrentAffairsScreen>{
 Set<String> saved={};Set<String> revised={};
 final items=const[
  _CA('Polity','Constitution & Governance','Revise constitutional bodies, important articles and recent governance themes.'),
  _CA('Economy','RBI & Banking','Revise monetary policy tools, banking terms, inflation and financial institutions.'),
  _CA('Science','Science & Technology','Focus on space, defence, health, environment and major scientific developments.'),
  _CA('Awards','Awards & Appointments','Track major national/international awards and important appointments.'),
  _CA('Sports','Sports Current Affairs','Revise tournaments, winners, venues, records and Indian achievements.'),
  _CA('World','International Affairs','Focus on summits, organisations, reports, indices and India-related developments.')
 ];
 @override void initState(){super.initState();load();}
 Future<void> load()async{final p=await SharedPreferences.getInstance();if(mounted)setState((){saved=(p.getStringList('ca_saved')??[]).toSet();revised=(p.getStringList('ca_revised')??[]).toSet();});}
 Future<void> saveState()async{final p=await SharedPreferences.getInstance();await p.setStringList('ca_saved',saved.toList());await p.setStringList('ca_revised',revised.toList());}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('GK & Current Affairs')),body:ListView(padding:const EdgeInsets.all(20),children:[
  Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('Daily Revision Mission',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800)),const SizedBox(height:8),Text(revised.length.toString()+'/'+items.length.toString()+' areas revised'),const SizedBox(height:10),LinearProgressIndicator(value:revised.length/items.length)]))),
  const SizedBox(height:16),
  ...items.map((x)=>Card(child:ExpansionTile(leading:CircleAvatar(child:Text(x.category.substring(0,1))),title:Text(x.title,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text(x.category),children:[Padding(padding:const EdgeInsets.fromLTRB(16,0,16,14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(x.note),const SizedBox(height:12),Row(children:[FilterChip(label:const Text('Saved'),selected:saved.contains(x.title),onSelected:(v){setState(()=>v?saved.add(x.title):saved.remove(x.title));saveState();}),const SizedBox(width:8),FilterChip(label:const Text('Revised'),selected:revised.contains(x.title),onSelected:(v){setState(()=>v?revised.add(x.title):revised.remove(x.title));saveState();})])]))]))),
  const SizedBox(height:12),
  Card(child:ListTile(leading:const Icon(Icons.quiz_rounded),title:const Text('Daily CA Quiz',style:TextStyle(fontWeight:FontWeight.w700)),subtitle:const Text('Quiz engine hook ready for verified daily question feed'),trailing:const Icon(Icons.lock_clock_rounded)))
 ]));
}
class _CA{final String category,title,note;const _CA(this.category,this.title,this.note);}

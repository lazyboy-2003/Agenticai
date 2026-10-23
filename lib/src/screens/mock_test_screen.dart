import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class MockTestScreen extends StatefulWidget{const MockTestScreen({super.key});@override State<MockTestScreen> createState()=>_MockTestScreenState();}
class _MockTestScreenState extends State<MockTestScreen>{
 final questions=const [
  _Q('25% of 240 is?',['50','60','70','80'],1,'25% = 1/4, so 240 ÷ 4 = 60.','Math'),
  _Q('If A:B = 2:3 and A = 20, B = ?',['25','30','35','40'],1,'2 parts = 20, so 1 part = 10 and 3 parts = 30.','Math'),
  _Q('Choose the synonym of Rapid.',['Slow','Quick','Weak','Late'],1,'Rapid means quick or fast.','English'),
  _Q('Article 21 of the Indian Constitution relates to?',['Equality','Life and personal liberty','Religion','Education only'],1,'Article 21 protects life and personal liberty.','GK/GS'),
  _Q('2, 6, 12, 20, ?',['28','30','32','36'],1,'Differences are 4, 6, 8, then 10; 20 + 10 = 30.','Reasoning'),
 ];
 int index=0,seconds=300;Map<int,int> answers={};Timer? timer;bool finished=false;
 @override void initState(){super.initState();timer=Timer.periodic(const Duration(seconds:1),(_){if(seconds<=1){finish();}else if(mounted){setState(()=>seconds--);}});}
 @override void dispose(){timer?.cancel();super.dispose();}
 double get score{double s=0;for(var i=0;i<questions.length;i++){if(!answers.containsKey(i))continue;s+=answers[i]==questions[i].answer?1:-0.25;}return s;}
 Future<void> finish()async{if(finished)return;timer?.cancel();setState(()=>finished=true);final correct=[for(var i=0;i<questions.length;i++)if(answers[i]==questions[i].answer)i].length;final p=await SharedPreferences.getInstance();await p.setInt('last_mock_correct',correct);await p.setInt('last_mock_total',questions.length);await p.setDouble('last_mock_score',score);}
 @override Widget build(BuildContext context){if(finished)return _result();final q=questions[index];return Scaffold(appBar:AppBar(title:const Text('Quick Mock Test'),actions:[Padding(padding:const EdgeInsets.all(16),child:Text((seconds~/60).toString().padLeft(2,'0')+':'+(seconds%60).toString().padLeft(2,'0'),style:const TextStyle(fontWeight:FontWeight.bold)))]),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  LinearProgressIndicator(value:(index+1)/questions.length),const SizedBox(height:20),Text(q.subject+' • Question '+(index+1).toString()+'/'+questions.length.toString()),const SizedBox(height:12),Text(q.text,style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight:FontWeight.w700)),const SizedBox(height:16),
  ...List.generate(q.options.length,(i)=>Card(child:RadioListTile<int>(value:i,groupValue:answers[index],onChanged:(v)=>setState(()=>answers[index]=v!),title:Text(q.options[i])))),
  const Spacer(),Row(children:[if(index>0)OutlinedButton(onPressed:()=>setState(()=>index--),child:const Text('Previous')),const Spacer(),FilledButton(onPressed:index==questions.length-1?finish:()=>setState(()=>index++),child:Text(index==questions.length-1?'Submit':'Next'))])
 ])));}
 Widget _result(){final correct=[for(var i=0;i<questions.length;i++)if(answers[i]==questions[i].answer)i].length;final accuracy=answers.isEmpty?0:(correct/answers.length*100).round();return Scaffold(appBar:AppBar(title:const Text('Mock Result')),body:ListView(padding:const EdgeInsets.all(20),children:[
  Text('Score: '+score.toStringAsFixed(2)+' / '+questions.length.toString(),style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w800)),Text('Correct: '+correct.toString()+' • Attempted: '+answers.length.toString()+' • Accuracy: '+accuracy.toString()+'%'),const SizedBox(height:20),
  ...List.generate(questions.length,(i){final q=questions[i],ok=answers[i]==q.answer;return Card(child:ExpansionTile(leading:Icon(ok?Icons.check_circle:Icons.cancel),title:Text(q.text),subtitle:Text(ok?'Correct':answers.containsKey(i)?'Incorrect (-0.25)':'Not attempted'),children:[Padding(padding:const EdgeInsets.all(16),child:Text('Answer: '+q.options[q.answer]+'\n\nSolution: '+q.solution))]));})
 ]));}
}
class _Q{final String text,solution,subject;final List<String> options;final int answer;const _Q(this.text,this.options,this.answer,this.solution,this.subject);}

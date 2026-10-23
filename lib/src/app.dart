import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
class AgenticAIApp extends StatefulWidget {
  const AgenticAIApp({super.key});
  @override State<AgenticAIApp> createState()=>_AgenticAIAppState();
}
class _AgenticAIAppState extends State<AgenticAIApp>{
  bool? onboarded;
  @override void initState(){super.initState();load();}
  Future<void> load()async{final p=await SharedPreferences.getInstance();if(mounted)setState(()=>onboarded=p.getBool('onboarding_done')??false);}
  @override Widget build(BuildContext context)=>MaterialApp(debugShowCheckedModeBanner:false,title:'AgenticAI',theme:ThemeData(colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFF3F51B5)),useMaterial3:true,scaffoldBackgroundColor:const Color(0xFFF7F8FC),inputDecorationTheme:const InputDecorationTheme(filled:true),cardTheme:const CardThemeData(elevation:0,margin:EdgeInsets.zero)),home:onboarded==null?const Scaffold(body:Center(child:CircularProgressIndicator())):onboarded!?const HomeScreen():OnboardingScreen(onComplete:()=>setState(()=>onboarded=true)));
}
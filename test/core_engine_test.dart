import 'package:flutter_test/flutter_test.dart';
import 'package:agenticai/src/services/agentic_brain.dart';
import 'package:agenticai/src/services/exam_preparation_engine.dart';

void main(){
  test('agent asks for diagnostic mock without baseline',(){
    final d=AgenticBrain.decide(accuracy:0,mockTotal:0,completedTopics:0,weak:const ['Math'],hours:3,daysLeft:30);
    expect(d.title,'Take a diagnostic mock');
  });
  test('SSC preparation includes geometry',(){
    final topics=ExamPreparationEngine.topicsFor('SSC CGL');
    expect(topics.any((t)=>t.chapter=='Geometry & Mensuration'),isTrue);
  });
}

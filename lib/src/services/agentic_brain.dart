class AgentDecision {
  final String title, reason, action;
  const AgentDecision(this.title,this.reason,this.action);
}
class AgenticBrain {
  static AgentDecision decide({required int accuracy,required int mockTotal,required int completedTopics,required List<String> weak,required double hours,required int daysLeft}) {
    final w=weak.isEmpty?'your weakest subject':weak.first;
    if(mockTotal==0)return AgentDecision('Take a diagnostic mock','The agent needs a baseline before changing your plan.','Complete one timed quick mock, then review every error.');
    if(daysLeft<=7)return AgentDecision('Exam-week mode','Only '+daysLeft.toString()+' days remain. New topics now have lower value.','Revise high-priority topics, attempt a timed mock, and review mistakes.');
    if(accuracy<60)return AgentDecision('Repair accuracy in '+w,'Your latest accuracy is '+accuracy.toString()+'%, so concept gaps matter more than speed.','Spend 50% of today on concepts/PYQ, 30% on practice, 20% on mistake revision.');
    if(accuracy<80)return AgentDecision('Timed PYQ on '+w,'Your base is improving; the next gain should come from accuracy under time pressure.','Do a timed PYQ set, analyse errors, then revise the two weakest concepts.');
    if(completedTopics<10)return AgentDecision('Expand syllabus coverage','Accuracy is strong but syllabus coverage is still limited.','Finish one high-priority chapter, then do a short mixed quiz.');
    return const AgentDecision('Full mock + spaced revision','Your accuracy and coverage support exam-mode practice.','Attempt a full mock and schedule mistakes for 1, 3 and 7-day revision.');
  }
}

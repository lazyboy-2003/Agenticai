class ExamTopic {
  final String subject, chapter, priority;
  const ExamTopic(this.subject,this.chapter,this.priority);
}
class ExamPreparationEngine {
  static List<ExamTopic> topicsFor(String exam) {
    final common=<ExamTopic>[
      const ExamTopic('Math','Percentage','High'),const ExamTopic('Math','Ratio & Proportion','High'),const ExamTopic('Math','Profit & Loss','High'),
      const ExamTopic('Math','Time & Work','High'),const ExamTopic('Math','Time, Speed & Distance','High'),const ExamTopic('Math','Algebra','Medium'),
      const ExamTopic('Reasoning','Analogy & Classification','High'),const ExamTopic('Reasoning','Series','High'),const ExamTopic('Reasoning','Coding-Decoding','High'),
      const ExamTopic('English','Grammar & Error Detection','High'),const ExamTopic('English','Vocabulary','High'),const ExamTopic('English','Reading Comprehension','Medium'),
      const ExamTopic('GK/GS','History','High'),const ExamTopic('GK/GS','Geography','High'),const ExamTopic('GK/GS','Polity','High'),const ExamTopic('GK/GS','General Science','High'),
      const ExamTopic('Current Affairs','National & International','High'),
    ];
    if(exam.contains('SSC')) return [...common,const ExamTopic('Math','Geometry & Mensuration','High'),const ExamTopic('English','Cloze Test','High')];
    if(exam.contains('RRB')) return [...common,const ExamTopic('Math','Number System','High'),const ExamTopic('GK/GS','Railway-focused General Awareness','Medium')];
    if(exam=='Banking') return [...common,const ExamTopic('Math','Data Interpretation','High'),const ExamTopic('Reasoning','Puzzles & Seating Arrangement','High'),const ExamTopic('English','Banking English','Medium')];
    return [...common,const ExamTopic('GK/GS','State GK','High'),const ExamTopic('GK/GS','Indian Economy','Medium')];
  }
}

class AspirantProfile {
  final String name, exam, language;
  final double dailyHours;
  final DateTime? targetDate;
  final List<String> weakSubjects;
  const AspirantProfile({required this.name, required this.exam, required this.dailyHours, required this.targetDate, required this.weakSubjects, required this.language});
}
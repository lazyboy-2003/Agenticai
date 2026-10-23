import 'package:flutter/material.dart';
import 'mentor_screen.dart';
import 'study_planner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  static final pages = <Widget>[
    _Dashboard(),
    const StudyPlannerScreen(),
    const MentorScreen(),
    _Placeholder(title: 'Progress', icon: Icons.insights_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Plan'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_rounded), label: 'Mentor'),
          NavigationDestination(icon: Icon(Icons.bar_chart_rounded), label: 'Progress'),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('AgenticAI', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('Your Government Job AI Mentor', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.auto_awesome_rounded, size: 32),
              const SizedBox(height: 12),
              Text("Today's Mission", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Set your target exam and daily study time. Your adaptive plan will appear here.'),
              const SizedBox(height: 16),
              FilledButton(onPressed: () {}, child: const Text('Set up my preparation')),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        const Row(children: [
          Expanded(child: _Stat(title: 'Readiness', value: '0%')),
          SizedBox(width: 12),
          Expanded(child: _Stat(title: 'Study streak', value: '0 days')),
        ]),
        const SizedBox(height: 16),
        Text('Preparation Hub', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        const _Action(icon: Icons.quiz_rounded, title: 'Mock Tests & PYQ', subtitle: 'Practice with exam-style questions'),
        const SizedBox(height: 10),
        const _Action(icon: Icons.error_outline_rounded, title: 'Mistake Book', subtitle: 'Turn mistakes into revision targets'),
        const SizedBox(height: 10),
        const _Action(icon: Icons.public_rounded, title: 'GK & Current Affairs', subtitle: 'Daily exam-focused revision'),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String title, value;
  const _Stat({required this.title, required this.value});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title),
      ]),
    ),
  );
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _Action({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    ),
  );
}

class _Placeholder extends StatelessWidget {
  final String title;
  final IconData icon;
  const _Placeholder({required this.title, required this.icon});
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 52),
      const SizedBox(height: 12),
      Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('Foundation ready — feature coming next.'),
    ]),
  );
}

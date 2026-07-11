import 'package:flutter/material.dart';

void main() {
  runApp(const LifeOsApp());
}

class LifeOsApp extends StatelessWidget {
  const LifeOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Life OS',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      ),
      home: const LifeOsHomePage(),
    );
  }
}

class LifeOsHomePage extends StatelessWidget {
  const LifeOsHomePage({super.key});

  static const List<_Metric> _todayMetrics = [
    _Metric('Daily Score', '78/100', Icons.speed, Color(0xFF2563EB)),
    _Metric('Tasks Done', '8 / 12', Icons.check_circle, Color(0xFF16A34A)),
    _Metric('Habit Streak', '14 days', Icons.local_fire_department, Color(0xFFF97316)),
    _Metric('Prayer Progress', '3 / 5', Icons.mosque, Color(0xFF7C3AED)),
  ];

  static const List<_FeatureArea> _featureAreas = [
    _FeatureArea('Daily Planner', 'Routine, tasks, notes, reviews and tomorrow planning', Icons.today),
    _FeatureArea('Goals', 'Personal goals with milestones, deadlines and progress', Icons.flag),
    _FeatureArea('Habit Tracker', 'Streaks, completion %, missed days and reminders', Icons.track_changes),
    _FeatureArea('Health', 'Manual logs plus Android Health Connect / Google Fit sync', Icons.favorite),
    _FeatureArea('Finance', 'INR income, expense, bank/UPI, bills and reports', Icons.account_balance_wallet),
    _FeatureArea('Prayer Tracker', 'Prayer, Quran, reminders, Ramadan and charity tracking', Icons.mosque),
    _FeatureArea('Journal & Notes', 'Diary, gratitude, ideas, reflections and daily reviews', Icons.edit_note),
    _FeatureArea('Offline Assistant', 'Rule-based summaries first; online AI later', Icons.auto_awesome),
  ];

  static const List<_FeatureArea> _comingSoonAreas = [
    _FeatureArea('Google Login', 'Optional when Firebase sync starts', Icons.login),
    _FeatureArea('Advanced Finance', 'Budgets, tax/GST, cards, loans and investments', Icons.trending_up),
    _FeatureArea('Documents Vault', 'IDs and private documents after secure storage', Icons.lock),
    _FeatureArea('Phone Analysis', 'SMS parsing and location history only after explicit opt-in', Icons.privacy_tip),
    _FeatureArea('Online AI', 'OpenAI or configurable provider in a later update', Icons.cloud),
    _FeatureArea('Sensitive Tracking', 'Password vault, SMS and location after security review', Icons.security),
  ];

  static const List<String> _implementationPhases = [
    'Update 1: Android-first app shell, navigation and reusable UI.',
    'Update 2: Offline-first models and repositories, ready for Firebase sync.',
    'Update 3: Planner, tasks, goals and habits MVP.',
    'Update 4: INR finance MVP for bank/UPI, bills and reports.',
    'Update 5: Prayer module with Quran, reminders, Ramadan and charity.',
    'Update 6: Health Connect / Google Fit with priority health metrics.',
    'Update 7: Daily, weekly and monthly reviews with offline summaries.',
    'Update 8: Optional Google login, Firebase backup, export and import.',
    'Update 9: Secure future modules and online AI feature flags.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life OS'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Quick Add'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const _HeroCard(),
            const SizedBox(height: 16),
            const _ProductDecisionCard(),
            const SizedBox(height: 16),
            _SectionHeader(title: 'Today at a glance', action: 'View report'),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _todayMetrics.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.65,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => _MetricCard(metric: _todayMetrics[index]),
            ),
            const SizedBox(height: 20),
            const _DailyFocusCard(),
            const SizedBox(height: 20),
            _SectionHeader(title: 'Life modules', action: '${_featureAreas.length} modules'),
            const SizedBox(height: 8),
            ..._featureAreas.map((area) => _FeatureTile(area: area)),
            const SizedBox(height: 20),
            _SectionHeader(title: 'Coming soon', action: '${_comingSoonAreas.length} later'),
            const SizedBox(height: 8),
            ..._comingSoonAreas.map((area) => _FeatureTile(area: area, comingSoon: true)),
            const SizedBox(height: 20),
            const _SectionHeader(title: 'Update roadmap'),
            const SizedBox(height: 8),
            ..._implementationPhases.indexed.map(
              (entry) => _RoadmapTile(step: entry.$1 + 1, text: entry.$2),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Life Operating System',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Android-first, offline-first command center with Firebase sync, Health Connect, prayer tracking and offline summaries.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () {},
              icon: const Icon(Icons.auto_graph),
              label: const Text('Start today review'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDecisionCard extends StatelessWidget {
  const _ProductDecisionCard();

  @override
  Widget build(BuildContext context) {
    const decisions = [
      'English only',
      'Android first',
      'Offline-first + Firebase sync',
      'No login first; Google login optional',
      'Offline summaries first',
      'Custom logo assets required',
    ];

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Locked product direction'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final decision in decisions)
                  Chip(
                    avatar: const Icon(Icons.check, size: 16),
                    label: Text(decision),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyFocusCard extends StatelessWidget {
  const _DailyFocusCard();

  @override
  Widget build(BuildContext context) {
    const items = ['Finish 3 priority tasks', 'Read Quran after Maghrib', 'Stay within food budget', 'Plan tomorrow before sleep'];
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Daily focus'),
            const SizedBox(height: 8),
            ...items.map(
              (item) => CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: item.startsWith('Finish'),
                onChanged: (_) {},
                title: Text(item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(metric.icon, color: metric.color),
            Text(metric.value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text(metric.label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.area, this.comingSoon = false});

  final _FeatureArea area;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(child: Icon(area.icon)),
        title: Text(area.title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(area.description),
        trailing: comingSoon
            ? const Chip(label: Text('Soon'))
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _RoadmapTile extends StatelessWidget {
  const _RoadmapTile({required this.step, required this.text});

  final int step;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('$step')),
      title: Text(text),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});

  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        if (action != null) Text(action!, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ],
    );
  }
}

class _Metric {
  const _Metric(this.label, this.value, this.icon, this.color);

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _FeatureArea {
  const _FeatureArea(this.title, this.description, this.icon);

  final String title;
  final String description;
  final IconData icon;
}

import 'package:flutter/material.dart';

import '../data/life_repository.dart';
import '../models/life_models.dart';
import '../widgets/life_widgets.dart';

class LifeOsShell extends StatefulWidget {
  const LifeOsShell({super.key, required this.repository});

  final InMemoryLifeRepository repository;

  @override
  State<LifeOsShell> createState() => _LifeOsShellState();
}

class _LifeOsShellState extends State<LifeOsShell> {
  int _selectedIndex = 0;

  late List<LifeTask> _tasks = widget.repository.getTasks();
  late List<Habit> _habits = widget.repository.getHabits();

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void _upsertTask(LifeTask task) {
    widget.repository.updateTask(task);
    setState(() => _tasks = widget.repository.getTasks());
  }

  void _addTask(String title, TaskArea area) {
    final task = LifeTask(
      id: 'task-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      area: area,
      completed: false,
    );
    _upsertTask(task);
  }

  void _toggleTask(LifeTask task, bool? completed) {
    _upsertTask(task.copyWith(completed: completed ?? false));
  }

  void _addHabit(String title) {
    final habit = Habit(
      id: 'habit-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      streak: 0,
      completedToday: false,
      missedDays: 0,
      reminderLabel: 'Reminder not set',
    );
    widget.repository.addHabit(habit);
    setState(() => _habits = widget.repository.getHabits());
  }

  void _toggleHabit(Habit habit, bool? completed) {
    final isCompleted = completed ?? false;
    widget.repository.updateHabit(
      habit.copyWith(
        completedToday: isCompleted,
        streak: isCompleted ? habit.streak + 1 : habit.streak,
      ),
    );
    setState(() => _habits = widget.repository.getHabits());
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        tasks: _tasks,
        habits: _habits,
        goals: widget.repository.getGoals(),
        financeEntries: widget.repository.getFinanceEntries(),
        healthEntries: widget.repository.getHealthEntries(),
        prayerRecords: widget.repository.getPrayerRecords(),
        reviews: widget.repository.getDailyReviews(),
        onOpenTab: _selectTab,
      ),
      PlannerScreen(
        tasks: _tasks,
        onAddTask: _addTask,
        onToggleTask: _toggleTask,
        onEditTask: _upsertTask,
      ),
      HabitsScreen(
        habits: _habits,
        goals: widget.repository.getGoals(),
        onAddHabit: _addHabit,
        onToggleHabit: _toggleHabit,
      ),
      FinanceScreen(entries: widget.repository.getFinanceEntries()),
      HealthScreen(entries: widget.repository.getHealthEntries()),
      MoreScreen(
        prayerRecords: widget.repository.getPrayerRecords(),
        notes: widget.repository.getNotes(),
        reviews: widget.repository.getDailyReviews(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Livelife'),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SafeArea(child: screens[_selectedIndex]),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () => showTaskEditor(
                context: context,
                onSave: (title, area) => _addTask(title, area),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            )
          : FloatingActionButton.extended(
              onPressed: () => _selectTab(1),
              icon: const Icon(Icons.add),
              label: const Text('Quick Add'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.today_outlined), selectedIcon: Icon(Icons.today), label: 'Planner'),
          NavigationDestination(icon: Icon(Icons.track_changes_outlined), selectedIcon: Icon(Icons.track_changes), label: 'Habits'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Finance'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Health'),
          NavigationDestination(icon: Icon(Icons.more_horiz), selectedIcon: Icon(Icons.more), label: 'More'),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.tasks,
    required this.habits,
    required this.goals,
    required this.financeEntries,
    required this.healthEntries,
    required this.prayerRecords,
    required this.reviews,
    required this.onOpenTab,
  });

  final List<LifeTask> tasks;
  final List<Habit> habits;
  final List<Goal> goals;
  final List<FinanceEntry> financeEntries;
  final List<HealthEntry> healthEntries;
  final List<PrayerRecord> prayerRecords;
  final List<DailyReview> reviews;
  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final completedTasks = tasks.where((task) => task.completed).length;
    final completedHabits = habits.where((habit) => habit.completedToday).length;
    final completedPrayers = prayerRecords.where((prayer) => prayer.completed).length;
    final income = financeEntries.where((entry) => entry.type == FinanceType.income).fold<double>(0, (sum, entry) => sum + entry.amountInr);
    final expense = financeEntries.where((entry) => entry.type == FinanceType.expense).fold<double>(0, (sum, entry) => sum + entry.amountInr);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _HeroCard(),
        const SizedBox(height: 16),
        const _ProductDecisionCard(),
        const SizedBox(height: 16),
        const SectionHeader(title: 'Today at a glance', action: 'Offline summary'),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            MetricCard(label: 'Tasks Done', value: '$completedTasks / ${tasks.length}', icon: Icons.check_circle, color: const Color(0xFF16A34A)),
            MetricCard(label: 'Habit Progress', value: '$completedHabits / ${habits.length}', icon: Icons.local_fire_department, color: const Color(0xFFF97316)),
            MetricCard(label: 'Prayer Progress', value: '$completedPrayers / 5', icon: Icons.mosque, color: const Color(0xFF7C3AED)),
            MetricCard(label: 'Balance', value: '₹${(income - expense).toStringAsFixed(0)}', icon: Icons.currency_rupee, color: const Color(0xFF2563EB)),
          ],
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Open your day'),
        FeatureTile(
          title: 'Daily Planner',
          description: 'Morning routine, tasks, evening review and tomorrow planning',
          icon: Icons.today,
          onTap: () => onOpenTab(1),
        ),
        FeatureTile(
          title: 'Habits & Goals',
          description: '${habits.length} habits and ${goals.length} active goals',
          icon: Icons.track_changes,
          onTap: () => onOpenTab(2),
        ),
        FeatureTile(
          title: 'Health Connect Ready',
          description: '${healthEntries.length} seeded health metrics with manual logs now',
          icon: Icons.favorite,
          onTap: () => onOpenTab(4),
        ),
        if (reviews.isNotEmpty)
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.auto_awesome)),
              title: const Text('Offline assistant summary'),
              subtitle: Text(reviews.first.summary),
            ),
          ),
      ],
    );
  }
}

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({
    super.key,
    required this.tasks,
    required this.onAddTask,
    required this.onToggleTask,
    required this.onEditTask,
  });

  final List<LifeTask> tasks;
  final void Function(String title, TaskArea area) onAddTask;
  final void Function(LifeTask task, bool? completed) onToggleTask;
  final ValueChanged<LifeTask> onEditTask;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(title: 'Daily Planner', action: '${tasks.length} items'),
        const SizedBox(height: 8),
        for (final area in TaskArea.values) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(_taskAreaLabel(area), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          ),
          ...tasks.where((task) => task.area == area).map(
                (task) => Card(
                  child: CheckboxListTile(
                    value: task.completed,
                    onChanged: (value) => onToggleTask(task, value),
                    title: Text(task.title),
                    subtitle: task.note == null ? null : Text(task.note!),
                    secondary: IconButton(
                      tooltip: 'Edit task',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => showTaskEditor(
                        context: context,
                        initialTask: task,
                        onSave: (title, area) => onEditTask(task.copyWith(title: title, area: area)),
                      ),
                    ),
                  ),
                ),
              ),
          if (!tasks.any((task) => task.area == area))
            EmptyStateCard(message: 'No ${_taskAreaLabel(area).toLowerCase()} yet.'),
        ],
      ],
    );
  }
}

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({
    super.key,
    required this.habits,
    required this.goals,
    required this.onAddHabit,
    required this.onToggleHabit,
  });

  final List<Habit> habits;
  final List<Goal> goals;
  final ValueChanged<String> onAddHabit;
  final void Function(Habit habit, bool? completed) onToggleHabit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionHeader(title: 'Habits'),
            FilledButton.icon(
              onPressed: () => showHabitEditor(context: context, onSave: onAddHabit),
              icon: const Icon(Icons.add),
              label: const Text('Add Habit'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final habit in habits)
          Card(
            child: CheckboxListTile(
              value: habit.completedToday,
              onChanged: (value) => onToggleHabit(habit, value),
              title: Text(habit.title),
              subtitle: Text('Streak: ${habit.streak} days • Missed: ${habit.missedDays} • Reminder: ${habit.reminderLabel ?? 'Not set'}'),
            ),
          ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Goals'),
        const SizedBox(height: 8),
        for (final goal in goals)
          Card(
            child: ListTile(
              title: Text(goal.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Deadline: ${goal.deadline.year}-${goal.deadline.month.toString().padLeft(2, '0')}-${goal.deadline.day.toString().padLeft(2, '0')}'),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: goal.progress),
                  const SizedBox(height: 8),
                  Text('Milestones: ${goal.milestones.join(', ')}'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key, required this.entries});

  final List<FinanceEntry> entries;

  @override
  Widget build(BuildContext context) {
    final income = entries.where((entry) => entry.type == FinanceType.income).fold<double>(0, (sum, entry) => sum + entry.amountInr);
    final expense = entries.where((entry) => entry.type == FinanceType.expense).fold<double>(0, (sum, entry) => sum + entry.amountInr);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Finance', action: 'INR • Bank / UPI'),
        const SizedBox(height: 8),
        MetricCard(label: 'Monthly Balance', value: '₹${(income - expense).toStringAsFixed(0)}', icon: Icons.currency_rupee, color: const Color(0xFF2563EB)),
        for (final entry in entries)
          Card(
            child: ListTile(
              leading: Icon(entry.type == FinanceType.income ? Icons.south_west : Icons.north_east),
              title: Text(entry.title),
              subtitle: Text(entry.accountLabel),
              trailing: Text('₹${entry.amountInr.toStringAsFixed(0)}'),
            ),
          ),
        const FeatureTile(
          title: 'Advanced finance',
          description: 'Budgets, tax/GST, cards, loans and investments are planned later',
          icon: Icons.trending_up,
          comingSoon: true,
        ),
      ],
    );
  }
}

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key, required this.entries});

  final List<HealthEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Health', action: 'Health Connect ready'),
        const SizedBox(height: 8),
        const FeatureTile(
          title: 'Android Health Connect / Google Fit',
          description: 'Permission-first integration boundary for steps, sleep, workouts and more',
          icon: Icons.health_and_safety,
          comingSoon: true,
        ),
        for (final entry in entries)
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.monitor_heart)),
              title: Text(_healthMetricLabel(entry.type)),
              subtitle: Text('Manual seed entry'),
              trailing: Text('${entry.value.toStringAsFixed(entry.value.truncateToDouble() == entry.value ? 0 : 1)} ${entry.unit}'),
            ),
          ),
      ],
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({
    super.key,
    required this.prayerRecords,
    required this.notes,
    required this.reviews,
  });

  final List<PrayerRecord> prayerRecords;
  final List<LifeNote> notes;
  final List<DailyReview> reviews;

  @override
  Widget build(BuildContext context) {
    final completedPrayers = prayerRecords.where((prayer) => prayer.completed).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(title: 'More', action: '$completedPrayers / 5 prayers'),
        const SizedBox(height: 8),
        const FeatureTile(
          title: 'Prayer calculation settings',
          description: 'Multiple methods, location, Asr option and manual adjustments',
          icon: Icons.settings,
          comingSoon: true,
        ),
        for (final prayer in prayerRecords)
          Card(
            child: ListTile(
              leading: Icon(prayer.completed ? Icons.check_circle : Icons.radio_button_unchecked),
              title: Text(prayer.name),
              subtitle: Text(prayer.timeLabel),
            ),
          ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Notes and reviews'),
        for (final note in notes) FeatureTile(title: note.title, description: note.body, icon: Icons.edit_note),
        for (final review in reviews) FeatureTile(title: 'Daily Review', description: review.tomorrowPlan, icon: Icons.rate_review),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Life Operating System',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Android-first, offline-first command center with Firebase sync, Health Connect, prayer tracking and offline summaries.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Locked product direction'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final decision in decisions) Chip(avatar: const Icon(Icons.check, size: 16), label: Text(decision)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showTaskEditor({
  required BuildContext context,
  required void Function(String title, TaskArea area) onSave,
  LifeTask? initialTask,
}) async {
  final controller = TextEditingController(text: initialTask?.title ?? '');
  var selectedArea = initialTask?.area ?? TaskArea.personal;

  await showDialog<void>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(initialTask == null ? 'Add Task' : 'Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Task title'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TaskArea>(
              value: selectedArea,
              decoration: const InputDecoration(labelText: 'Planner section'),
              items: [
                for (final area in TaskArea.values) DropdownMenuItem(value: area, child: Text(_taskAreaLabel(area))),
              ],
              onChanged: (value) => setDialogState(() => selectedArea = value ?? selectedArea),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isEmpty) {
                return;
              }
              onSave(title, selectedArea);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}

Future<void> showHabitEditor({
  required BuildContext context,
  required ValueChanged<String> onSave,
}) async {
  final controller = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Add Habit'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Habit title'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final title = controller.text.trim();
            if (title.isEmpty) {
              return;
            }
            onSave(title);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

String _taskAreaLabel(TaskArea area) {
  switch (area) {
    case TaskArea.routine:
      return 'Morning Routine';
    case TaskArea.work:
      return 'Work Tasks';
    case TaskArea.personal:
      return 'Personal Tasks';
    case TaskArea.notes:
      return 'Notes';
    case TaskArea.review:
      return 'Evening Review';
    case TaskArea.tomorrow:
      return 'Tomorrow Planning';
  }
}

String _healthMetricLabel(HealthMetricType type) {
  switch (type) {
    case HealthMetricType.steps:
      return 'Steps';
    case HealthMetricType.sleep:
      return 'Sleep Duration';
    case HealthMetricType.water:
      return 'Water Intake';
    case HealthMetricType.weight:
      return 'Weight';
    case HealthMetricType.exercise:
      return 'Exercise / Workout';
    case HealthMetricType.mood:
      return 'Mood';
    case HealthMetricType.medicine:
      return 'Medicine Tracking';
  }
}

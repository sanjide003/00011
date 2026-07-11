import 'package:flutter/material.dart';

import '../data/life_repository.dart';
import '../models/life_models.dart';
import '../services/life_calculations.dart';
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
  late List<PrayerRecord> _prayerRecords = widget.repository.getPrayerRecords();

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

  void _togglePrayer(PrayerRecord prayer, bool? completed) {
    widget.repository.updatePrayerRecord(
      PrayerRecord(
        id: prayer.id,
        name: prayer.name,
        completed: completed ?? false,
        timeLabel: prayer.timeLabel,
      ),
    );
    setState(() => _prayerRecords = widget.repository.getPrayerRecords());
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
        prayerRecords: _prayerRecords,
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
        prayerRecords: _prayerRecords,
        onTogglePrayer: _togglePrayer,
        notes: widget.repository.getNotes(),
        reviews: widget.repository.getDailyReviews(),
      ),
    ];

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
    final summary = calculateFinanceSummary(entries);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Finance', action: 'INR • Bank / UPI'),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            MetricCard(label: 'Income', value: '₹${summary.incomeInr.toStringAsFixed(0)}', icon: Icons.south_west, color: const Color(0xFF16A34A)),
            MetricCard(label: 'Expense', value: '₹${summary.expenseInr.toStringAsFixed(0)}', icon: Icons.north_east, color: const Color(0xFFDC2626)),
            MetricCard(label: 'Pending Bills', value: '₹${summary.pendingBillsInr.toStringAsFixed(0)}', icon: Icons.receipt_long, color: const Color(0xFFF97316)),
            MetricCard(label: 'Cash Flow', value: '₹${summary.cashFlowInr.toStringAsFixed(0)}', icon: Icons.account_balance_wallet, color: const Color(0xFF2563EB)),
          ],
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Basic reports', action: 'This month'),
        for (final entry in entries)
          Card(
            child: ListTile(
              leading: Icon(_financeIcon(entry.type)),
              title: Text(entry.title),
              subtitle: Text('${_financeTypeLabel(entry.type)} • ${entry.accountLabel}'),
              trailing: Text('₹${entry.amountInr.toStringAsFixed(0)}'),
            ),
          ),
        const FeatureTile(
          title: 'Advanced finance',
          description: 'Categories, budget rules, tax/GST, investments, loans and credit cards are coming soon',
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
    final summary = calculateHealthSummary(entries);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionHeader(title: 'Health', action: 'Manual + Health Connect'),
        const SizedBox(height: 8),
        const FeatureTile(
          title: 'Permission required before sync',
          description: 'No background tracking starts until you explicitly connect Android Health Connect / Google Fit',
          icon: Icons.privacy_tip,
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            MetricCard(label: 'Steps', value: summary.steps.toStringAsFixed(0), icon: Icons.directions_walk, color: const Color(0xFF2563EB)),
            MetricCard(label: 'Sleep', value: '${summary.sleepHours.toStringAsFixed(1)} h', icon: Icons.bedtime, color: const Color(0xFF7C3AED)),
            MetricCard(label: 'Water', value: '${summary.waterLiters.toStringAsFixed(1)} L', icon: Icons.water_drop, color: const Color(0xFF0891B2)),
            MetricCard(label: 'Exercise', value: '${summary.exerciseMinutes.toStringAsFixed(0)} min', icon: Icons.fitness_center, color: const Color(0xFF16A34A)),
          ],
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Primary manual logs'),
        for (final entry in entries)
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.monitor_heart)),
              title: Text(_healthMetricLabel(entry.type)),
              subtitle: Text('Manual entry now • Sync adapter later'),
              trailing: Text('${entry.value.toStringAsFixed(entry.value.truncateToDouble() == entry.value ? 0 : 1)} ${entry.unit}'),
            ),
          ),
        const SectionHeader(title: 'Secondary metrics'),
        const FeatureTile(title: 'Heart Rate', description: 'Coming with permission-based health sync', icon: Icons.favorite, comingSoon: true),
        const FeatureTile(title: 'Blood Pressure', description: 'Coming with manual logs and supported devices', icon: Icons.bloodtype, comingSoon: true),
        const FeatureTile(title: 'Blood Sugar', description: 'Coming with manual logs and supported devices', icon: Icons.monitor_heart, comingSoon: true),
        const FeatureTile(title: 'Calories, distance, active minutes and BMI', description: 'Coming after primary health metrics are stable', icon: Icons.insights, comingSoon: true),
      ],
    );
  }
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({
    super.key,
    required this.prayerRecords,
    required this.onTogglePrayer,
    required this.notes,
    required this.reviews,
  });

  final List<PrayerRecord> prayerRecords;
  final void Function(PrayerRecord prayer, bool? completed) onTogglePrayer;
  final List<LifeNote> notes;
  final List<DailyReview> reviews;

  @override
  Widget build(BuildContext context) {
    final progress = calculatePrayerProgress(prayerRecords);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionHeader(title: 'Prayer', action: '${progress.label} prayers'),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress.ratio),
        const SizedBox(height: 12),
        for (final prayer in prayerRecords)
          Card(
            child: CheckboxListTile(
              value: prayer.completed,
              onChanged: (value) => onTogglePrayer(prayer, value),
              title: Text(prayer.name),
              subtitle: Text(prayer.timeLabel),
              secondary: const Icon(Icons.mosque),
            ),
          ),
        const SectionHeader(title: 'Prayer tools'),
        const FeatureTile(
          title: 'Prayer calculation settings',
          description: 'Multiple methods, automatic/manual location, Asr option, timezone and manual adjustments',
          icon: Icons.settings,
          comingSoon: true,
        ),
        const FeatureTile(title: 'Reminder settings', description: 'Per-prayer reminders and quiet-time controls', icon: Icons.notifications_active, comingSoon: true),
        const FeatureTile(title: 'Quran tracking', description: 'Pages, verses and sessions', icon: Icons.menu_book, comingSoon: true),
        const FeatureTile(title: 'Dhikr and dua', description: 'Daily counters and saved duas', icon: Icons.favorite, comingSoon: true),
        const FeatureTile(title: 'Ramadan and charity', description: 'Fasting, charity and Ramadan goals', icon: Icons.volunteer_activism, comingSoon: true),
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

IconData _financeIcon(FinanceType type) {
  switch (type) {
    case FinanceType.income:
      return Icons.south_west;
    case FinanceType.expense:
      return Icons.north_east;
    case FinanceType.bill:
      return Icons.receipt_long;
  }
}

String _financeTypeLabel(FinanceType type) {
  switch (type) {
    case FinanceType.income:
      return 'Income';
    case FinanceType.expense:
      return 'Expense';
    case FinanceType.bill:
      return 'Pending bill';
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

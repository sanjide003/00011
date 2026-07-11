import 'package:flutter/material.dart';

import '../data/life_repository.dart';
import '../models/life_models.dart';
import '../services/finance_calculations.dart';
import '../services/health_calculations.dart';
import '../services/health_integration_services.dart';
import '../services/life_reports.dart';
import '../services/prayer_calculations.dart';
import '../services/reminder_services.dart';
import '../services/sync_services.dart';
import '../widgets/life_widgets.dart';

class LifeOsShell extends StatefulWidget {
  const LifeOsShell({super.key, required this.repository});

  final LocalLifeRepository repository;

  @override
  State<LifeOsShell> createState() => _LifeOsShellState();
}

class _LifeOsShellState extends State<LifeOsShell> {
  int _selectedIndex = 0;
  late List<LifeTask> _tasks = widget.repository.getTasks();
  late List<Habit> _habits = widget.repository.getHabits();
  late List<Goal> _goals = widget.repository.getGoals();
  late List<FinanceEntry> _financeEntries = widget.repository.getFinanceEntries();
  late List<HealthEntry> _healthEntries = widget.repository.getHealthEntries();
  late List<PrayerRecord> _prayerRecords = widget.repository.getPrayerRecords();
  late List<LifeNote> _notes = widget.repository.getNotes();
  late List<DailyReview> _reviews = widget.repository.getDailyReviews();
  AuthState _authState = const AuthState.signedOut();
  SyncState _syncState = const SyncState.localOnly();
  PrivacySettings _privacySettings = const PrivacySettings(firebaseBackupEnabled: false, exportEnabled: true, importEnabled: true);
  ReminderSettings _reminderSettings = const ReminderScheduler().defaultSettings();
  HealthIntegrationState _healthIntegrationState = const HealthIntegrationState.notConnected();

  void _refresh() {
    setState(() {
      _tasks = widget.repository.getTasks();
      _habits = widget.repository.getHabits();
      _goals = widget.repository.getGoals();
      _financeEntries = widget.repository.getFinanceEntries();
      _healthEntries = widget.repository.getHealthEntries();
      _prayerRecords = widget.repository.getPrayerRecords();
      _notes = widget.repository.getNotes();
      _reviews = widget.repository.getDailyReviews();
    });
  }

  void _selectTab(int index) => setState(() => _selectedIndex = index);

  void _addTask(String title, TaskArea area) {
    widget.repository.addTask(LifeTask(id: 'task-${DateTime.now().microsecondsSinceEpoch}', title: title, area: area, completed: false));
    _refresh();
  }

  void _toggleTask(LifeTask task, bool? completed) {
    widget.repository.updateTask(task.copyWith(completed: completed ?? false));
    _refresh();
  }

  void _editTask(LifeTask task) {
    widget.repository.updateTask(task);
    _refresh();
  }

  void _addHabit(String title) {
    widget.repository.addHabit(Habit(id: 'habit-${DateTime.now().microsecondsSinceEpoch}', title: title, streak: 0, completedToday: false, missedDays: 0, reminderLabel: 'Reminder not set'));
    _refresh();
  }

  void _toggleHabit(Habit habit, bool? completed) {
    final isCompleted = completed ?? false;
    widget.repository.updateHabit(habit.copyWith(completedToday: isCompleted, streak: isCompleted ? habit.streak + 1 : habit.streak));
    _refresh();
  }

  void _togglePrayer(PrayerRecord prayer, bool? completed) {
    widget.repository.updatePrayerRecord(prayer.copyWith(completed: completed ?? false));
    _refresh();
  }

  void _toggleOptionalSignIn() {
    setState(() {
      if (_authState.isSignedIn) {
        _authState = const AuthState.signedOut();
        _syncState = const FirebaseSyncAdapter().signedOutState();
        _privacySettings = _privacySettings.copyWith(firebaseBackupEnabled: false);
      } else {
        _authState = const AuthState.signedIn(displayName: 'Livelife User', email: 'user@example.com');
        _syncState = const FirebaseSyncAdapter().signedInReadyState();
      }
    });
  }

  void _toggleFirebaseBackup(bool value) {
    setState(() {
      _privacySettings = _privacySettings.copyWith(firebaseBackupEnabled: value);
      _syncState = value ? const FirebaseSyncAdapter().queuedState(1) : const SyncState.localOnly();
    });
  }

  void _grantNotificationPermission() {
    setState(() => _reminderSettings = const ReminderScheduler().requestAndroidPermission(_reminderSettings, userGranted: true));
  }

  void _denyNotificationPermission() {
    setState(() => _reminderSettings = const ReminderScheduler().requestAndroidPermission(_reminderSettings, userGranted: false));
  }

  void _toggleReminder(String id, bool enabled) {
    setState(() => _reminderSettings = const ReminderScheduler().setPreferenceEnabled(_reminderSettings, id, enabled));
  }

  void _connectHealthIntegration() {
    final boundary = const HealthIntegrationBoundary();
    final state = boundary.requestPermissions(
      available: true,
      grantedTypes: const [HealthDataType.steps, HealthDataType.sleep, HealthDataType.exercise, HealthDataType.weight],
    );
    for (final entry in boundary.readAllowedSampleData(state, DateTime.now())) {
      widget.repository.updateHealthEntry(entry);
    }
    setState(() {
      _healthIntegrationState = state;
      _healthEntries = widget.repository.getHealthEntries();
    });
  }

  void _denyHealthIntegration() {
    setState(() {
      _healthIntegrationState = const HealthIntegrationBoundary().requestPermissions(available: true, grantedTypes: const []);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(tasks: _tasks, habits: _habits, goals: _goals, financeEntries: _financeEntries, healthEntries: _healthEntries, prayerRecords: _prayerRecords, reviews: _reviews, onOpenTab: _selectTab),
      PlannerScreen(tasks: _tasks, onAddTask: _addTask, onToggleTask: _toggleTask, onEditTask: _editTask),
      HabitsScreen(
        habits: _habits,
        goals: _goals,
        onAddHabit: _addHabit,
        onToggleHabit: _toggleHabit,
        onAddGoal: (goal) {
          widget.repository.addGoal(goal);
          _refresh();
        },
        onDeleteGoal: (id) {
          widget.repository.deleteGoal(id);
          _refresh();
        },
      ),
      FinanceScreen(
        entries: _financeEntries,
        onAddEntry: (entry) {
          widget.repository.addFinanceEntry(entry);
          _refresh();
        },
        onUpdateEntry: (entry) {
          widget.repository.updateFinanceEntry(entry);
          _refresh();
        },
        onDeleteEntry: (id) {
          widget.repository.deleteFinanceEntry(id);
          _refresh();
        },
      ),
      HealthScreen(
        entries: _healthEntries,
        integrationState: _healthIntegrationState,
        onConnectHealth: _connectHealthIntegration,
        onDenyHealth: _denyHealthIntegration,
        onAddEntry: (entry) {
          widget.repository.addHealthEntry(entry);
          _refresh();
        },
        onDeleteEntry: (id) {
          widget.repository.deleteHealthEntry(id);
          _refresh();
        },
      ),
      MoreScreen(
        prayerRecords: _prayerRecords,
        onTogglePrayer: _togglePrayer,
        notes: _notes,
        reviews: _reviews,
        authState: _authState,
        syncState: _syncState,
        privacySettings: _privacySettings,
        reminderSettings: _reminderSettings,
        onGrantNotifications: _grantNotificationPermission,
        onDenyNotifications: _denyNotificationPermission,
        onToggleReminder: _toggleReminder,
        onToggleSignIn: _toggleOptionalSignIn,
        onToggleBackup: _toggleFirebaseBackup,
        onAddNote: (note) {
          widget.repository.addNote(note);
          _refresh();
        },
        onDeleteNote: (id) {
          widget.repository.deleteNote(id);
          _refresh();
        },
        onAddReview: (review) {
          widget.repository.addDailyReview(review);
          _refresh();
        },
        onDeleteReview: (id) {
          widget.repository.deleteDailyReview(id);
          _refresh();
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Livelife'), actions: [IconButton(tooltip: 'Notifications', onPressed: () {}, icon: const Icon(Icons.notifications_none))]),
      body: SafeArea(child: screens[_selectedIndex]),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(onPressed: () => showTaskEditor(context: context, onSave: _addTask), icon: const Icon(Icons.add), label: const Text('Add Task'))
          : FloatingActionButton.extended(onPressed: () => _selectTab(1), icon: const Icon(Icons.add), label: const Text('Quick Add')),
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
  const DashboardScreen({super.key, required this.tasks, required this.habits, required this.goals, required this.financeEntries, required this.healthEntries, required this.prayerRecords, required this.reviews, required this.onOpenTab});

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
    final dailyReport = buildDailyClosingReport(tasks: tasks, habits: habits, financeEntries: financeEntries, healthEntries: healthEntries, prayerRecords: prayerRecords);
    final weeklyReview = buildWeeklyReview(tasks: tasks, habits: habits, financeEntries: financeEntries, prayerRecords: prayerRecords);
    final monthlyReview = buildMonthlyReview(goals: goals, financeEntries: financeEntries, habits: habits);

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
        FeatureTile(title: 'Daily Planner', description: 'Morning routine, tasks, evening review and tomorrow planning', icon: Icons.today, onTap: () => onOpenTab(1)),
        FeatureTile(title: 'Habits & Goals', description: '${habits.length} habits and ${goals.length} active goals', icon: Icons.track_changes, onTap: () => onOpenTab(2)),
        FeatureTile(title: 'Health Connect Ready', description: '${healthEntries.length} health metrics with manual logs now', icon: Icons.favorite, onTap: () => onOpenTab(4)),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Offline reports'),
        _ReportCard(report: dailyReport),
        _ReportCard(report: weeklyReview),
        _ReportCard(report: monthlyReview),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Local suggestions', action: 'No online AI'),
        for (final suggestion in dailyReport.suggestions) Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.lightbulb_outline)), title: Text(suggestion))),
        if (reviews.isNotEmpty) Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.auto_awesome)), title: const Text('Offline assistant summary'), subtitle: Text(reviews.first.summary))),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});
  final LifeReport report;

  @override
  Widget build(BuildContext context) => Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.summarize)), title: Text(report.title), subtitle: Text(report.summary)));
}

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key, required this.tasks, required this.onAddTask, required this.onToggleTask, required this.onEditTask});

  final List<LifeTask> tasks;
  final void Function(String title, TaskArea area) onAddTask;
  final void Function(LifeTask task, bool? completed) onToggleTask;
  final ValueChanged<LifeTask> onEditTask;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionHeader(title: 'Daily Planner', action: '${tasks.length} items'),
          const SizedBox(height: 8),
          for (final area in TaskArea.values) ...[
            Padding(padding: const EdgeInsets.only(top: 12, bottom: 4), child: Text(_taskAreaLabel(area), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))),
            ...tasks.where((task) => task.area == area).map((task) => Card(child: CheckboxListTile(value: task.completed, onChanged: (value) => onToggleTask(task, value), title: Text(task.title), subtitle: task.note == null ? null : Text(task.note!), secondary: IconButton(tooltip: 'Edit task', icon: const Icon(Icons.edit_outlined), onPressed: () => showTaskEditor(context: context, initialTask: task, onSave: (title, area) => onEditTask(task.copyWith(title: title, area: area))))))),
            if (!tasks.any((task) => task.area == area)) EmptyStateCard(message: 'No ${_taskAreaLabel(area).toLowerCase()} yet.'),
          ],
        ],
      );
}

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key, required this.habits, required this.goals, required this.onAddHabit, required this.onToggleHabit, required this.onAddGoal, required this.onDeleteGoal});

  final List<Habit> habits;
  final List<Goal> goals;
  final ValueChanged<String> onAddHabit;
  final void Function(Habit habit, bool? completed) onToggleHabit;
  final ValueChanged<Goal> onAddGoal;
  final ValueChanged<String> onDeleteGoal;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const SectionHeader(title: 'Habits'), FilledButton.icon(onPressed: () => showHabitEditor(context: context, onSave: onAddHabit), icon: const Icon(Icons.add), label: const Text('Add Habit'))]),
          const SizedBox(height: 8),
          for (final habit in habits) Card(child: CheckboxListTile(value: habit.completedToday, onChanged: (value) => onToggleHabit(habit, value), title: Text(habit.title), subtitle: Text('Streak: ${habit.streak} days • Missed: ${habit.missedDays} • Reminder: ${habit.reminderLabel ?? 'Not set'}'))),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const SectionHeader(title: 'Goals'), OutlinedButton.icon(onPressed: () => showGoalEditor(context: context, onSave: onAddGoal), icon: const Icon(Icons.add), label: const Text('Add Goal'))]),
          const SizedBox(height: 8),
          for (final goal in goals)
            Card(
              child: ListTile(
                title: Text(goal.title),
                trailing: IconButton(tooltip: 'Delete goal', icon: const Icon(Icons.delete_outline), onPressed: () => onDeleteGoal(goal.id)),
                subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Deadline: ${goal.deadline.year}-${goal.deadline.month.toString().padLeft(2, '0')}-${goal.deadline.day.toString().padLeft(2, '0')}'),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: goal.progress),
                  const SizedBox(height: 8),
                  Text('Milestones: ${goal.milestones.join(', ')}'),
                ]),
              ),
            ),
        ],
      );
}

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key, required this.entries, required this.onAddEntry, required this.onUpdateEntry, required this.onDeleteEntry});

  final List<FinanceEntry> entries;
  final ValueChanged<FinanceEntry> onAddEntry;
  final ValueChanged<FinanceEntry> onUpdateEntry;
  final ValueChanged<String> onDeleteEntry;

  @override
  Widget build(BuildContext context) {
    final summary = calculateFinanceSummary(entries);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const SectionHeader(title: 'Finance', action: 'INR • Bank / UPI'), FilledButton.icon(onPressed: () => showFinanceEditor(context: context, onSave: onAddEntry), icon: const Icon(Icons.add), label: const Text('Add Entry'))]),
        const SizedBox(height: 8),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.65, crossAxisSpacing: 12, mainAxisSpacing: 12, children: [
          MetricCard(label: 'Income', value: '₹${summary.incomeInr.toStringAsFixed(0)}', icon: Icons.south_west, color: const Color(0xFF16A34A)),
          MetricCard(label: 'Expense', value: '₹${summary.expenseInr.toStringAsFixed(0)}', icon: Icons.north_east, color: const Color(0xFFDC2626)),
          MetricCard(label: 'Pending Bills', value: '₹${summary.pendingBillsInr.toStringAsFixed(0)}', icon: Icons.receipt_long, color: const Color(0xFFF97316)),
          MetricCard(label: 'Cash Flow', value: '₹${summary.cashFlowInr.toStringAsFixed(0)}', icon: Icons.account_balance_wallet, color: const Color(0xFF2563EB)),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Basic reports', action: 'This month'),
        for (final entry in entries) Card(child: ListTile(leading: Icon(_financeIcon(entry.type)), title: Text(entry.title), subtitle: Text('${financeTypeLabel(entry.type)} • ${entry.accountLabel}${entry.type == FinanceType.bill && entry.paid ? ' • Paid' : ''}'), trailing: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [Text('₹${entry.amountInr.toStringAsFixed(0)}'), if (entry.type == FinanceType.bill && !entry.paid) IconButton(tooltip: 'Mark paid', icon: const Icon(Icons.done_all), onPressed: () => onUpdateEntry(entry.copyWith(paid: true))), IconButton(tooltip: 'Delete finance entry', icon: const Icon(Icons.delete_outline), onPressed: () => onDeleteEntry(entry.id))]))),
        const FeatureTile(title: 'Advanced finance', description: 'Categories, budget rules, tax/GST, investments, loans and credit cards are coming soon', icon: Icons.trending_up, comingSoon: true),
      ],
    );
  }
}

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key, required this.entries, required this.integrationState, required this.onConnectHealth, required this.onDenyHealth, required this.onAddEntry, required this.onDeleteEntry});

  final List<HealthEntry> entries;
  final HealthIntegrationState integrationState;
  final VoidCallback onConnectHealth;
  final VoidCallback onDenyHealth;
  final ValueChanged<HealthEntry> onAddEntry;
  final ValueChanged<String> onDeleteEntry;

  @override
  Widget build(BuildContext context) {
    final summary = calculateHealthSummary(entries);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const SectionHeader(title: 'Health', action: 'Manual + Health Connect'), FilledButton.icon(onPressed: () => showHealthEditor(context: context, onSave: onAddEntry), icon: const Icon(Icons.add), label: const Text('Add Health'))]),
        const SizedBox(height: 8),
        FeatureTile(
          title: 'Permission required before sync',
          description: 'No background tracking starts until you explicitly connect Android Health Connect / Google Fit',
          icon: Icons.privacy_tip,
          action: FilledButton(onPressed: onConnectHealth, child: const Text('Connect')),
        ),
        FeatureTile(
          title: integrationState.label,
          description: integrationState.message,
          icon: Icons.health_and_safety,
          action: TextButton(onPressed: onDenyHealth, child: const Text('Deny')),
        ),
        const FeatureTile(title: 'Consent boundary', description: 'Steps, sleep, exercise and weight are read only after permission; water, mood and medicine stay manual-first', icon: Icons.verified_user),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 1.65, crossAxisSpacing: 12, mainAxisSpacing: 12, children: [
          MetricCard(label: 'Steps', value: summary.steps.toStringAsFixed(0), icon: Icons.directions_walk, color: const Color(0xFF2563EB)),
          MetricCard(label: 'Sleep', value: '${summary.sleepHours.toStringAsFixed(1)} h', icon: Icons.bedtime, color: const Color(0xFF7C3AED)),
          MetricCard(label: 'Water', value: '${summary.waterLiters.toStringAsFixed(1)} L', icon: Icons.water_drop, color: const Color(0xFF0891B2)),
          MetricCard(label: 'Exercise', value: '${summary.exerciseMinutes.toStringAsFixed(0)} min', icon: Icons.fitness_center, color: const Color(0xFF16A34A)),
        ]),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Primary manual logs'),
        for (final entry in entries) Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.monitor_heart)), title: Text(_healthMetricLabel(entry.type)), subtitle: const Text('Manual entry now • Sync adapter later'), trailing: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [Text('${entry.value.toStringAsFixed(entry.value.truncateToDouble() == entry.value ? 0 : 1)} ${entry.unit}'), IconButton(tooltip: 'Delete health entry', icon: const Icon(Icons.delete_outline), onPressed: () => onDeleteEntry(entry.id))]))),
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
  const MoreScreen({super.key, required this.prayerRecords, required this.onTogglePrayer, required this.notes, required this.reviews, required this.authState, required this.syncState, required this.privacySettings, required this.reminderSettings, required this.onGrantNotifications, required this.onDenyNotifications, required this.onToggleReminder, required this.onToggleSignIn, required this.onToggleBackup, required this.onAddNote, required this.onDeleteNote, required this.onAddReview, required this.onDeleteReview});

  final List<PrayerRecord> prayerRecords;
  final void Function(PrayerRecord prayer, bool? completed) onTogglePrayer;
  final List<LifeNote> notes;
  final List<DailyReview> reviews;
  final AuthState authState;
  final SyncState syncState;
  final PrivacySettings privacySettings;
  final ReminderSettings reminderSettings;
  final VoidCallback onGrantNotifications;
  final VoidCallback onDenyNotifications;
  final void Function(String id, bool enabled) onToggleReminder;
  final VoidCallback onToggleSignIn;
  final ValueChanged<bool> onToggleBackup;
  final ValueChanged<LifeNote> onAddNote;
  final ValueChanged<String> onDeleteNote;
  final ValueChanged<DailyReview> onAddReview;
  final ValueChanged<String> onDeleteReview;

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
        for (final prayer in prayerRecords) Card(child: CheckboxListTile(value: prayer.completed, onChanged: (value) => onTogglePrayer(prayer, value), title: Text(prayer.name), subtitle: Text(prayer.timeLabel), secondary: const Icon(Icons.mosque))),
        const SectionHeader(title: 'Prayer tools'),
        const FeatureTile(title: 'Prayer calculation settings', description: 'Multiple methods, automatic/manual location, Asr option, timezone and manual adjustments', icon: Icons.settings, comingSoon: true),
        const FeatureTile(title: 'Reminder settings', description: 'Per-prayer reminders and quiet-time controls', icon: Icons.notifications_active, comingSoon: true),
        const FeatureTile(title: 'Quran tracking', description: 'Pages, verses and sessions', icon: Icons.menu_book, comingSoon: true),
        const FeatureTile(title: 'Dhikr and dua', description: 'Daily counters and saved duas', icon: Icons.favorite, comingSoon: true),
        const FeatureTile(title: 'Ramadan and charity', description: 'Fasting, charity and Ramadan goals', icon: Icons.volunteer_activism, comingSoon: true),
        const SizedBox(height: 20),
        SectionHeader(title: 'Reminders', action: reminderSettings.permissionLabel),
        FeatureTile(
          title: 'Android notification permission',
          description: 'Reminders stay disabled until you allow notifications. Safe default: off.',
          icon: Icons.notifications_active,
          action: Wrap(spacing: 4, children: [
            FilledButton(onPressed: onGrantNotifications, child: const Text('Allow')),
            TextButton(onPressed: onDenyNotifications, child: const Text('Deny')),
          ]),
        ),
        for (final reminder in reminderSettings.preferences)
          SwitchListTile(
            value: reminder.enabled && reminderSettings.canSchedule,
            onChanged: reminderSettings.canSchedule ? (value) => onToggleReminder(reminder.id, value) : null,
            title: Text(reminder.title),
            subtitle: Text(reminder.timeLabel),
          ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'Backup and privacy'),
        FeatureTile(title: authState.label, description: 'Google login is optional. Livelife works without login and keeps local data first.', icon: Icons.account_circle, action: FilledButton(onPressed: onToggleSignIn, child: Text(authState.isSignedIn ? 'Sign Out' : 'Optional Google Login'))),
        SwitchListTile(value: privacySettings.firebaseBackupEnabled, onChanged: authState.isSignedIn ? onToggleBackup : null, title: const Text('Firebase backup opt-in'), subtitle: Text(syncState.label)),
        FeatureTile(title: 'Export / Import', description: 'Manual local backup files are prepared for privacy-first recovery', icon: Icons.import_export),
        FeatureTile(title: 'Conflict handling', description: syncState.conflictMessage ?? 'Local data wins until the user reviews a cloud conflict', icon: Icons.compare_arrows),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const SectionHeader(title: 'Notes and reviews'), OutlinedButton.icon(onPressed: () => showNoteEditor(context: context, onSave: onAddNote), icon: const Icon(Icons.add), label: const Text('Add Note'))]),
        for (final note in notes) FeatureTile(title: note.title, description: note.body, icon: Icons.edit_note, action: IconButton(tooltip: 'Delete note', icon: const Icon(Icons.delete_outline), onPressed: () => onDeleteNote(note.id))),
        OutlinedButton.icon(onPressed: () => showReviewEditor(context: context, onSave: onAddReview), icon: const Icon(Icons.rate_review), label: const Text('Add Daily Review')),
        for (final review in reviews) FeatureTile(title: 'Daily Review', description: review.tomorrowPlan, icon: Icons.rate_review, action: IconButton(tooltip: 'Delete review', icon: const Icon(Icons.delete_outline), onPressed: () => onDeleteReview(review.id))),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Personal Life Operating System', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Android-first, offline-first command center with Firebase sync, Health Connect, prayer tracking and offline summaries.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70)),
          ]),
        ),
      );
}

class _ProductDecisionCard extends StatelessWidget {
  const _ProductDecisionCard();

  @override
  Widget build(BuildContext context) {
    const decisions = ['English only', 'Android first', 'Offline-first + Firebase sync', 'No login first; Google login optional', 'Offline summaries first', 'Custom logo assets required'];
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SectionHeader(title: 'Locked product direction'), const SizedBox(height: 12), Wrap(spacing: 8, runSpacing: 8, children: [for (final decision in decisions) Chip(avatar: const Icon(Icons.check, size: 16), label: Text(decision))])])));
  }
}

Future<void> showTaskEditor({required BuildContext context, required void Function(String title, TaskArea area) onSave, LifeTask? initialTask}) async {
  final controller = TextEditingController(text: initialTask?.title ?? '');
  var selectedArea = initialTask?.area ?? TaskArea.personal;
  await showDialog<void>(context: context, builder: (context) => StatefulBuilder(builder: (context, setDialogState) => AlertDialog(title: Text(initialTask == null ? 'Add Task' : 'Edit Task'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Task title')), const SizedBox(height: 12), DropdownButtonFormField<TaskArea>(value: selectedArea, decoration: const InputDecoration(labelText: 'Planner section'), items: [for (final area in TaskArea.values) DropdownMenuItem(value: area, child: Text(_taskAreaLabel(area)))], onChanged: (value) => setDialogState(() => selectedArea = value ?? selectedArea))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { final title = controller.text.trim(); if (title.isEmpty) return; onSave(title, selectedArea); Navigator.pop(context); }, child: const Text('Save'))])));
}

Future<void> showHabitEditor({required BuildContext context, required ValueChanged<String> onSave}) async {
  final controller = TextEditingController();
  await showDialog<void>(context: context, builder: (context) => AlertDialog(title: const Text('Add Habit'), content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Habit title')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { final title = controller.text.trim(); if (title.isEmpty) return; onSave(title); Navigator.pop(context); }, child: const Text('Save'))]));
}

Future<void> showFinanceEditor({required BuildContext context, required ValueChanged<FinanceEntry> onSave}) async {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  var selectedType = FinanceType.expense;
  await showDialog<void>(context: context, builder: (context) => StatefulBuilder(builder: (context, setDialogState) => AlertDialog(title: const Text('Add Finance Entry'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: titleController, autofocus: true, decoration: const InputDecoration(labelText: 'Title')), TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount in INR')), DropdownButtonFormField<FinanceType>(value: selectedType, decoration: const InputDecoration(labelText: 'Type'), items: [for (final type in FinanceType.values) DropdownMenuItem(value: type, child: Text(financeTypeLabel(type)))], onChanged: (value) => setDialogState(() => selectedType = value ?? selectedType))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { final title = titleController.text.trim(); final amount = double.tryParse(amountController.text.trim()); if (title.isEmpty || amount == null) return; onSave(FinanceEntry(id: 'finance-${DateTime.now().microsecondsSinceEpoch}', title: title, amountInr: amount, type: selectedType, accountLabel: bankUpiAccountLabel, date: DateTime.now(), paid: selectedType != FinanceType.bill)); Navigator.pop(context); }, child: const Text('Save'))])));
}

Future<void> showHealthEditor({required BuildContext context, required ValueChanged<HealthEntry> onSave}) async {
  final valueController = TextEditingController();
  var selectedType = HealthMetricType.water;
  await showDialog<void>(context: context, builder: (context) => StatefulBuilder(builder: (context, setDialogState) => AlertDialog(title: const Text('Add Health Entry'), content: Column(mainAxisSize: MainAxisSize.min, children: [DropdownButtonFormField<HealthMetricType>(value: selectedType, decoration: const InputDecoration(labelText: 'Metric'), items: [for (final type in HealthMetricType.values) DropdownMenuItem(value: type, child: Text(_healthMetricLabel(type)))], onChanged: (value) => setDialogState(() => selectedType = value ?? selectedType)), TextField(controller: valueController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Value'))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { final value = double.tryParse(valueController.text.trim()); if (value == null) return; onSave(HealthEntry(id: 'health-${DateTime.now().microsecondsSinceEpoch}', type: selectedType, value: value, unit: _healthUnit(selectedType), recordedAt: DateTime.now())); Navigator.pop(context); }, child: const Text('Save'))])));
}

Future<void> showGoalEditor({required BuildContext context, required ValueChanged<Goal> onSave}) async {
  final controller = TextEditingController();
  await showDialog<void>(context: context, builder: (context) => AlertDialog(title: const Text('Add Goal'), content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Goal title')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { final title = controller.text.trim(); if (title.isEmpty) return; onSave(Goal(id: 'goal-${DateTime.now().microsecondsSinceEpoch}', title: title, category: GoalCategory.personal, deadline: DateTime.now().add(const Duration(days: 90)), progress: 0, milestones: const ['First milestone'])); Navigator.pop(context); }, child: const Text('Save'))]));
}

Future<void> showNoteEditor({required BuildContext context, required ValueChanged<LifeNote> onSave}) async {
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  await showDialog<void>(context: context, builder: (context) => AlertDialog(title: const Text('Add Note'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: titleController, autofocus: true, decoration: const InputDecoration(labelText: 'Title')), TextField(controller: bodyController, decoration: const InputDecoration(labelText: 'Body'))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { final title = titleController.text.trim(); if (title.isEmpty) return; onSave(LifeNote(id: 'note-${DateTime.now().microsecondsSinceEpoch}', title: title, body: bodyController.text.trim())); Navigator.pop(context); }, child: const Text('Save'))]));
}

Future<void> showReviewEditor({required BuildContext context, required ValueChanged<DailyReview> onSave}) async {
  final summaryController = TextEditingController();
  final planController = TextEditingController();
  await showDialog<void>(context: context, builder: (context) => AlertDialog(title: const Text('Add Daily Review'), content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: summaryController, autofocus: true, decoration: const InputDecoration(labelText: 'Summary')), TextField(controller: planController, decoration: const InputDecoration(labelText: 'Tomorrow plan'))]), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () { final summary = summaryController.text.trim(); if (summary.isEmpty) return; onSave(DailyReview(id: 'review-${DateTime.now().microsecondsSinceEpoch}', date: DateTime.now(), summary: summary, tomorrowPlan: planController.text.trim())); Navigator.pop(context); }, child: const Text('Save'))]));
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

String _healthUnit(HealthMetricType type) {
  switch (type) {
    case HealthMetricType.steps:
      return 'steps';
    case HealthMetricType.sleep:
      return 'h';
    case HealthMetricType.water:
      return 'L';
    case HealthMetricType.weight:
      return 'kg';
    case HealthMetricType.exercise:
      return 'min';
    case HealthMetricType.mood:
      return '/5';
    case HealthMetricType.medicine:
      return 'taken';
  }
}

import '../models/life_models.dart';

abstract class LifeRepository {
  List<LifeTask> getTasks();
  List<Habit> getHabits();
  List<Goal> getGoals();
  List<FinanceEntry> getFinanceEntries();
  List<HealthEntry> getHealthEntries();
  List<PrayerRecord> getPrayerRecords();
  List<LifeNote> getNotes();
  List<DailyReview> getDailyReviews();
}

abstract class TaskRepository {
  List<LifeTask> getTasks();
  void addTask(LifeTask task);
  void updateTask(LifeTask task);
}

abstract class HabitRepository {
  List<Habit> getHabits();
  void addHabit(Habit habit);
  void updateHabit(Habit habit);
}

abstract class GoalRepository {
  List<Goal> getGoals();
}

abstract class FinanceRepository {
  List<FinanceEntry> getFinanceEntries();
  void addFinanceEntry(FinanceEntry entry);
}

abstract class HealthRepository {
  List<HealthEntry> getHealthEntries();
  void addHealthEntry(HealthEntry entry);
}

abstract class PrayerRepository {
  List<PrayerRecord> getPrayerRecords();
  void updatePrayerRecord(PrayerRecord record);
}

abstract class NotesRepository {
  List<LifeNote> getNotes();
}

abstract class ReviewRepository {
  List<DailyReview> getDailyReviews();
}

class InMemoryLifeRepository
    implements
        LifeRepository,
        TaskRepository,
        HabitRepository,
        GoalRepository,
        FinanceRepository,
        HealthRepository,
        PrayerRepository,
        NotesRepository,
        ReviewRepository {
  InMemoryLifeRepository({
    required List<LifeTask> tasks,
    required List<Habit> habits,
    required List<Goal> goals,
    required List<FinanceEntry> financeEntries,
    required List<HealthEntry> healthEntries,
    required List<PrayerRecord> prayerRecords,
    required List<LifeNote> notes,
    required List<DailyReview> dailyReviews,
  })  : _tasks = tasks,
        _habits = habits,
        _goals = goals,
        _financeEntries = financeEntries,
        _healthEntries = healthEntries,
        _prayerRecords = prayerRecords,
        _notes = notes,
        _dailyReviews = dailyReviews;

  factory InMemoryLifeRepository.seeded() {
    final now = DateTime.now();
    return InMemoryLifeRepository(
      tasks: [
        const LifeTask(
          id: 'task-morning-quran',
          title: 'Read Quran after Fajr',
          area: TaskArea.routine,
          completed: true,
        ),
        const LifeTask(
          id: 'task-work-priority',
          title: 'Finish top 3 priority tasks',
          area: TaskArea.work,
          completed: false,
        ),
        const LifeTask(
          id: 'task-review',
          title: 'Write evening review',
          area: TaskArea.review,
          completed: false,
        ),
        const LifeTask(
          id: 'task-tomorrow',
          title: 'Plan tomorrow before sleep',
          area: TaskArea.tomorrow,
          completed: false,
        ),
      ],
      habits: const [
        Habit(
          id: 'habit-water',
          title: 'Drink 2.5L water',
          streak: 9,
          completedToday: false,
          missedDays: 1,
          reminderLabel: 'Every 2 hours',
        ),
        Habit(
          id: 'habit-walk',
          title: 'Walk 8,000 steps',
          streak: 14,
          completedToday: true,
          missedDays: 0,
          reminderLabel: '7:00 PM',
        ),
        Habit(
          id: 'habit-sleep',
          title: 'Sleep before 11:00 PM',
          streak: 5,
          completedToday: false,
          missedDays: 2,
          reminderLabel: '10:15 PM',
        ),
      ],
      goals: [
        Goal(
          id: 'goal-health',
          title: 'Build a consistent health routine',
          category: GoalCategory.health,
          deadline: now.add(const Duration(days: 90)),
          progress: 0.42,
          milestones: const ['Track steps daily', 'Exercise 4x weekly', 'Sleep before 11 PM'],
        ),
        Goal(
          id: 'goal-finance',
          title: 'Save ₹50,000 emergency fund',
          category: GoalCategory.finance,
          deadline: now.add(const Duration(days: 180)),
          progress: 0.28,
          milestones: const ['Track expenses', 'Save weekly', 'Review monthly'],
        ),
      ],
      financeEntries: [
        FinanceEntry(
          id: 'finance-salary',
          title: 'Salary',
          amountInr: 55000,
          type: FinanceType.income,
          accountLabel: 'Bank / UPI',
          date: now,
        ),
        FinanceEntry(
          id: 'finance-groceries',
          title: 'Groceries',
          amountInr: 1850,
          type: FinanceType.expense,
          accountLabel: 'Bank / UPI',
          date: now,
        ),
        FinanceEntry(
          id: 'finance-electricity-bill',
          title: 'Electricity bill',
          amountInr: 1240,
          type: FinanceType.bill,
          accountLabel: 'Bank / UPI',
          date: now.add(const Duration(days: 3)),
        ),
      ],
      healthEntries: [
        HealthEntry(
          id: 'health-steps',
          type: HealthMetricType.steps,
          value: 6400,
          unit: 'steps',
          recordedAt: now,
        ),
        HealthEntry(
          id: 'health-water',
          type: HealthMetricType.water,
          value: 1.8,
          unit: 'L',
          recordedAt: now,
        ),
        HealthEntry(
          id: 'health-sleep',
          type: HealthMetricType.sleep,
          value: 6.5,
          unit: 'h',
          recordedAt: now,
        ),
        HealthEntry(
          id: 'health-weight',
          type: HealthMetricType.weight,
          value: 72,
          unit: 'kg',
          recordedAt: now,
        ),
        HealthEntry(
          id: 'health-exercise',
          type: HealthMetricType.exercise,
          value: 35,
          unit: 'min',
          recordedAt: now,
        ),
        HealthEntry(
          id: 'health-mood',
          type: HealthMetricType.mood,
          value: 4,
          unit: '/5',
          recordedAt: now,
        ),
        HealthEntry(
          id: 'health-medicine',
          type: HealthMetricType.medicine,
          value: 1,
          unit: 'taken',
          recordedAt: now,
        ),
      ],
      prayerRecords: const [
        PrayerRecord(id: 'fajr', name: 'Fajr', completed: true, timeLabel: '5:05 AM'),
        PrayerRecord(id: 'dhuhr', name: 'Dhuhr', completed: true, timeLabel: '12:28 PM'),
        PrayerRecord(id: 'asr', name: 'Asr', completed: false, timeLabel: '3:47 PM'),
        PrayerRecord(id: 'maghrib', name: 'Maghrib', completed: false, timeLabel: '6:52 PM'),
        PrayerRecord(id: 'isha', name: 'Isha', completed: false, timeLabel: '8:04 PM'),
      ],
      notes: const [
        LifeNote(id: 'note-idea', title: 'Life OS idea', body: 'Keep the app personal and Android-first.'),
      ],
      dailyReviews: [
        DailyReview(
          id: 'review-today',
          date: now,
          summary: 'Good progress on habits and planning.',
          tomorrowPlan: 'Complete planner MVP and review finances.',
        ),
      ],
    );
  }

  final List<LifeTask> _tasks;
  final List<Habit> _habits;
  final List<Goal> _goals;
  final List<FinanceEntry> _financeEntries;
  final List<HealthEntry> _healthEntries;
  final List<PrayerRecord> _prayerRecords;
  final List<LifeNote> _notes;
  final List<DailyReview> _dailyReviews;

  @override
  List<LifeTask> getTasks() => List.unmodifiable(_tasks);

  @override
  List<Habit> getHabits() => List.unmodifiable(_habits);

  @override
  List<Goal> getGoals() => List.unmodifiable(_goals);

  @override
  List<FinanceEntry> getFinanceEntries() => List.unmodifiable(_financeEntries);

  @override
  List<HealthEntry> getHealthEntries() => List.unmodifiable(_healthEntries);

  @override
  List<PrayerRecord> getPrayerRecords() => List.unmodifiable(_prayerRecords);

  @override
  List<LifeNote> getNotes() => List.unmodifiable(_notes);

  @override
  List<DailyReview> getDailyReviews() => List.unmodifiable(_dailyReviews);

  @override
  void addTask(LifeTask task) => _tasks.add(task);

  @override
  void updateTask(LifeTask task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      _tasks.add(task);
    } else {
      _tasks[index] = task;
    }
  }

  @override
  void addHabit(Habit habit) => _habits.add(habit);

  @override
  void updateHabit(Habit habit) {
    final index = _habits.indexWhere((item) => item.id == habit.id);
    if (index == -1) {
      _habits.add(habit);
    } else {
      _habits[index] = habit;
    }
  }

  @override
  void addFinanceEntry(FinanceEntry entry) => _financeEntries.add(entry);

  @override
  void addHealthEntry(HealthEntry entry) => _healthEntries.add(entry);

  @override
  void updatePrayerRecord(PrayerRecord record) {
    final index = _prayerRecords.indexWhere((item) => item.id == record.id);
    if (index == -1) {
      _prayerRecords.add(record);
    } else {
      _prayerRecords[index] = record;
    }
  }
}

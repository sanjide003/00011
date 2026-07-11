enum TaskArea { routine, work, personal, notes, review, tomorrow }

enum GoalCategory { personal, health, finance, prayer, learning }

enum FinanceType { income, expense, bill }

enum HealthMetricType { steps, sleep, water, weight, exercise, mood, medicine }

class LifeTask {
  const LifeTask({
    required this.id,
    required this.title,
    required this.area,
    required this.completed,
    this.note,
  });

  final String id;
  final String title;
  final TaskArea area;
  final bool completed;
  final String? note;

  LifeTask copyWith({String? title, TaskArea? area, bool? completed, String? note}) {
    return LifeTask(
      id: id,
      title: title ?? this.title,
      area: area ?? this.area,
      completed: completed ?? this.completed,
      note: note ?? this.note,
    );
  }
}

class Habit {
  const Habit({
    required this.id,
    required this.title,
    required this.streak,
    required this.completedToday,
    required this.missedDays,
    this.reminderLabel,
  });

  final String id;
  final String title;
  final int streak;
  final bool completedToday;
  final int missedDays;
  final String? reminderLabel;

  Habit copyWith({
    String? title,
    int? streak,
    bool? completedToday,
    int? missedDays,
    String? reminderLabel,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      streak: streak ?? this.streak,
      completedToday: completedToday ?? this.completedToday,
      missedDays: missedDays ?? this.missedDays,
      reminderLabel: reminderLabel ?? this.reminderLabel,
    );
  }
}

class Goal {
  const Goal({
    required this.id,
    required this.title,
    required this.category,
    required this.deadline,
    required this.progress,
    required this.milestones,
  });

  final String id;
  final String title;
  final GoalCategory category;
  final DateTime deadline;
  final double progress;
  final List<String> milestones;
}

class FinanceEntry {
  const FinanceEntry({
    required this.id,
    required this.title,
    required this.amountInr,
    required this.type,
    required this.accountLabel,
    required this.date,
  });

  final String id;
  final String title;
  final double amountInr;
  final FinanceType type;
  final String accountLabel;
  final DateTime date;
}

class HealthEntry {
  const HealthEntry({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.recordedAt,
  });

  final String id;
  final HealthMetricType type;
  final double value;
  final String unit;
  final DateTime recordedAt;
}

class PrayerRecord {
  const PrayerRecord({
    required this.id,
    required this.name,
    required this.completed,
    required this.timeLabel,
  });

  final String id;
  final String name;
  final bool completed;
  final String timeLabel;
}

class LifeNote {
  const LifeNote({required this.id, required this.title, required this.body});

  final String id;
  final String title;
  final String body;
}

class DailyReview {
  const DailyReview({
    required this.id,
    required this.date,
    required this.summary,
    required this.tomorrowPlan,
  });

  final String id;
  final DateTime date;
  final String summary;
  final String tomorrowPlan;
}

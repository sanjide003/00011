import '../models/life_models.dart';

class FinanceSummary {
  const FinanceSummary({
    required this.incomeInr,
    required this.expenseInr,
    required this.pendingBillsInr,
  });

  final double incomeInr;
  final double expenseInr;
  final double pendingBillsInr;

  double get cashFlowInr => incomeInr - expenseInr - pendingBillsInr;
}

class PrayerProgress {
  const PrayerProgress({required this.completed, required this.total});

  final int completed;
  final int total;

  double get ratio => total == 0 ? 0 : completed / total;
  String get label => '$completed / $total';
}

class HealthSummary {
  const HealthSummary({
    required this.steps,
    required this.sleepHours,
    required this.waterLiters,
    required this.weightKg,
    required this.exerciseMinutes,
    required this.moodScore,
    required this.medicineTaken,
  });

  final double steps;
  final double sleepHours;
  final double waterLiters;
  final double weightKg;
  final double exerciseMinutes;
  final double moodScore;
  final double medicineTaken;
}

FinanceSummary calculateFinanceSummary(List<FinanceEntry> entries) {
  double income = 0;
  double expense = 0;
  double bills = 0;

  for (final entry in entries) {
    switch (entry.type) {
      case FinanceType.income:
        income += entry.amountInr;
        break;
      case FinanceType.expense:
        expense += entry.amountInr;
        break;
      case FinanceType.bill:
        bills += entry.amountInr;
        break;
    }
  }

  return FinanceSummary(incomeInr: income, expenseInr: expense, pendingBillsInr: bills);
}

PrayerProgress calculatePrayerProgress(List<PrayerRecord> records) {
  return PrayerProgress(
    completed: records.where((record) => record.completed).length,
    total: records.length,
  );
}

HealthSummary calculateHealthSummary(List<HealthEntry> entries) {
  double valueFor(HealthMetricType type) {
    final matches = entries.where((entry) => entry.type == type);
    if (matches.isEmpty) {
      return 0;
    }
    return matches.last.value;
  }

  return HealthSummary(
    steps: valueFor(HealthMetricType.steps),
    sleepHours: valueFor(HealthMetricType.sleep),
    waterLiters: valueFor(HealthMetricType.water),
    weightKg: valueFor(HealthMetricType.weight),
    exerciseMinutes: valueFor(HealthMetricType.exercise),
    moodScore: valueFor(HealthMetricType.mood),
    medicineTaken: valueFor(HealthMetricType.medicine),
  );
}

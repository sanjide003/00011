import 'package:flutter_test/flutter_test.dart';
import 'package:sanjid_app/src/data/life_repository.dart';
import 'package:sanjid_app/src/models/life_models.dart';
import 'package:sanjid_app/src/services/life_calculations.dart';

void main() {
  test('finance summary calculates INR cash flow with bills', () {
    final summary = calculateFinanceSummary([
      FinanceEntry(
        id: 'income',
        title: 'Salary',
        amountInr: 50000,
        type: FinanceType.income,
        accountLabel: 'Bank / UPI',
        date: DateTime(2026),
      ),
      FinanceEntry(
        id: 'expense',
        title: 'Food',
        amountInr: 2500,
        type: FinanceType.expense,
        accountLabel: 'Bank / UPI',
        date: DateTime(2026),
      ),
      FinanceEntry(
        id: 'bill',
        title: 'Electricity',
        amountInr: 1200,
        type: FinanceType.bill,
        accountLabel: 'Bank / UPI',
        date: DateTime(2026),
      ),
    ]);

    expect(summary.incomeInr, 50000);
    expect(summary.expenseInr, 2500);
    expect(summary.pendingBillsInr, 1200);
    expect(summary.cashFlowInr, 46300);
  });

  test('prayer progress counts completed prayers', () {
    final progress = calculatePrayerProgress(InMemoryLifeRepository.seeded().getPrayerRecords());

    expect(progress.total, 5);
    expect(progress.completed, 2);
    expect(progress.label, '2 / 5');
  });

  test('health summary prioritizes primary health metrics', () {
    final summary = calculateHealthSummary(InMemoryLifeRepository.seeded().getHealthEntries());

    expect(summary.steps, 6400);
    expect(summary.sleepHours, 6.5);
    expect(summary.waterLiters, 1.8);
    expect(summary.weightKg, 72);
    expect(summary.exerciseMinutes, 35);
    expect(summary.moodScore, 4);
    expect(summary.medicineTaken, 1);
  });
}

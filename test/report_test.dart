import 'package:flutter_test/flutter_test.dart';
import 'package:sanjid_app/src/data/life_repository.dart';
import 'package:sanjid_app/src/services/life_reports.dart';
import 'package:sanjid_app/src/services/sync_config.dart';

void main() {
  test('daily closing report uses local data and offline suggestions', () {
    final repository = InMemoryLifeRepository.seeded();
    final report = buildDailyClosingReport(
      tasks: repository.getTasks(),
      habits: repository.getHabits(),
      financeEntries: repository.getFinanceEntries(),
      healthEntries: repository.getHealthEntries(),
      prayerRecords: repository.getPrayerRecords(),
    );

    expect(report.title, 'Daily closing report');
    expect(report.summary, contains('tasks'));
    expect(report.summary, contains('prayers'));
    expect(report.suggestions, isNotEmpty);
    expect(report.suggestions.any((suggestion) => suggestion.contains('Prayer progress')), isTrue);
  });

  test('weekly and monthly reviews are generated without online AI', () {
    final repository = InMemoryLifeRepository.seeded();

    final weekly = buildWeeklyReview(
      tasks: repository.getTasks(),
      habits: repository.getHabits(),
      financeEntries: repository.getFinanceEntries(),
      prayerRecords: repository.getPrayerRecords(),
    );
    final monthly = buildMonthlyReview(
      goals: repository.getGoals(),
      financeEntries: repository.getFinanceEntries(),
      habits: repository.getHabits(),
    );

    expect(weekly.title, 'Weekly review');
    expect(monthly.title, 'Monthly review');
    expect(weekly.suggestions, isNotEmpty);
    expect(monthly.suggestions, isNotEmpty);
  });

  test('sync defaults keep the app local-first and signed out', () {
    expect(defaultSyncStatus.authState, AuthState.signedOut);
    expect(defaultSyncStatus.syncState, SyncState.readyForFirebase);
    expect(defaultSyncStatus.isSignedIn, isFalse);
  });

  test('future advanced modules are disabled behind security requirements', () {
    expect(futureAdvancedFeatures, isNotEmpty);
    expect(futureAdvancedFeatures.every((feature) => feature.enabled == false), isTrue);
    expect(
      futureAdvancedFeatures.any((feature) => feature.title == 'Password vault' && feature.requirement.contains('encryption')),
      isTrue,
    );
    expect(
      futureAdvancedFeatures.any((feature) => feature.title == 'Online AI assistant' && feature.requirement.contains('Offline summaries')),
      isTrue,
    );
  });
}

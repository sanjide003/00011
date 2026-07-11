import 'package:flutter_test/flutter_test.dart';
import 'package:livelife/src/data/life_repository.dart';
import 'package:livelife/src/models/life_models.dart';
import 'package:livelife/src/services/prayer_calculations.dart';

void main() {
  test('calculates five-prayer progress from seeded records', () {
    final progress = calculatePrayerProgress(InMemoryLifeRepository.seeded().getPrayerRecords());

    expect(progress.total, 5);
    expect(progress.completed, 2);
    expect(progress.label, '2 / 5');
    expect(progress.ratio, 0.4);
  });

  test('updates prayer completion through repository', () {
    final repository = InMemoryLifeRepository.seeded();
    const updatedAsr = PrayerRecord(
      id: 'asr',
      name: 'Asr',
      completed: true,
      timeLabel: '3:47 PM',
    );

    repository.updatePrayerRecord(updatedAsr);

    final progress = calculatePrayerProgress(repository.getPrayerRecords());
    expect(progress.completed, 3);
  });
}

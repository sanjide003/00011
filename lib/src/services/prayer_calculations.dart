import '../models/life_models.dart';

class PrayerProgress {
  const PrayerProgress({required this.completed, required this.total});

  final int completed;
  final int total;

  double get ratio => total == 0 ? 0 : completed / total;
  String get label => '$completed / $total';
}

PrayerProgress calculatePrayerProgress(List<PrayerRecord> prayers) {
  return PrayerProgress(
    completed: prayers.where((prayer) => prayer.completed).length,
    total: prayers.length,
  );
}

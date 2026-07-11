import 'package:flutter_test/flutter_test.dart';
import 'package:sanjid_app/src/data/life_repository.dart';
import 'package:sanjid_app/src/models/life_models.dart';

void main() {
  group('InMemoryLifeRepository', () {
    test('seeds core Life OS data for Update 2', () {
      final repository = InMemoryLifeRepository.seeded();

      expect(repository.getTasks(), isNotEmpty);
      expect(repository.getHabits(), isNotEmpty);
      expect(repository.getGoals(), isNotEmpty);
      expect(repository.getFinanceEntries().first.accountLabel, 'Bank / UPI');
      expect(repository.getHealthEntries(), isNotEmpty);
      expect(repository.getPrayerRecords(), hasLength(5));
      expect(repository.getNotes(), isNotEmpty);
      expect(repository.getDailyReviews(), isNotEmpty);
    });

    test('adds and updates tasks through the repository interface', () {
      final repository = InMemoryLifeRepository.seeded();
      const task = LifeTask(
        id: 'task-test',
        title: 'Test task',
        area: TaskArea.personal,
        completed: false,
      );

      repository.addTask(task);
      expect(repository.getTasks().any((item) => item.id == 'task-test'), isTrue);

      repository.updateTask(task.copyWith(completed: true));
      final updatedTask = repository.getTasks().firstWhere((item) => item.id == 'task-test');
      expect(updatedTask.completed, isTrue);
    });

    test('adds and updates habits through the repository interface', () {
      final repository = InMemoryLifeRepository.seeded();
      const habit = Habit(
        id: 'habit-test',
        title: 'Test habit',
        streak: 0,
        completedToday: false,
        missedDays: 0,
      );

      repository.addHabit(habit);
      repository.updateHabit(habit.copyWith(completedToday: true, streak: 1));

      final updatedHabit = repository.getHabits().firstWhere((item) => item.id == 'habit-test');
      expect(updatedHabit.completedToday, isTrue);
      expect(updatedHabit.streak, 1);
    });
  });
}

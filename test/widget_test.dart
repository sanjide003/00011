import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:livelife/main.dart';

void main() {
  testWidgets('Life OS shell renders dashboard and bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());

    expect(find.text('Livelife'), findsOneWidget);
    expect(find.text('Personal Life Operating System'), findsOneWidget);
    expect(find.text('Locked product direction'), findsOneWidget);
    expect(find.text('Offline-first + Firebase sync'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Planner'), findsOneWidget);
    expect(find.text('Habits'), findsOneWidget);
    expect(find.text('Finance'), findsOneWidget);
    expect(find.text('Health'), findsOneWidget);
    expect(find.text('More'), findsOneWidget);
  });

  testWidgets('Planner supports adding and completing a task', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());

    await tester.tap(find.text('Planner'));
    await tester.pumpAndSettle();

    expect(find.text('Daily Planner'), findsOneWidget);

    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Call doctor');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Call doctor'), findsOneWidget);

    final taskTile = find.ancestor(
      of: find.text('Call doctor'),
      matching: find.byType(CheckboxListTile),
    );
    await tester.tap(taskTile);
    await tester.pumpAndSettle();

    final checkbox = tester.widget<CheckboxListTile>(taskTile);
    expect(checkbox.value, isTrue);
  });

  testWidgets('Habits tab renders goals and habit controls', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());

    await tester.tap(find.text('Habits'));
    await tester.pumpAndSettle();

    expect(find.text('Habits'), findsWidgets);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Add Habit'), findsOneWidget);
    expect(find.text('Build a consistent health routine'), findsOneWidget);
  });
}

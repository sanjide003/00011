import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanjid_app/main.dart';

void main() {
  testWidgets('Life OS shell renders dashboard and bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());

    expect(find.text('Life OS'), findsOneWidget);
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

  testWidgets('Finance tab renders INR summary and coming soon finance scope', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());

    await tester.tap(find.text('Finance'));
    await tester.pumpAndSettle();

    expect(find.text('INR • Bank / UPI'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);
    expect(find.text('Pending Bills'), findsOneWidget);
    expect(find.text('Cash Flow'), findsOneWidget);
    expect(find.text('Advanced finance'), findsOneWidget);
  });

  testWidgets('More tab renders prayer progress and prayer placeholders', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();

    expect(find.text('Prayer'), findsOneWidget);
    expect(find.text('2 / 5 prayers'), findsOneWidget);
    expect(find.text('Prayer calculation settings'), findsOneWidget);
    expect(find.text('Reminder settings'), findsOneWidget);
    expect(find.text('Quran tracking'), findsOneWidget);
    expect(find.text('Dhikr and dua'), findsOneWidget);
    expect(find.text('Ramadan and charity'), findsOneWidget);
  });

  testWidgets('Health tab renders permission boundary and primary metrics', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());

    await tester.tap(find.text('Health'));
    await tester.pumpAndSettle();

    expect(find.text('Permission required before sync'), findsOneWidget);
    expect(find.text('Steps'), findsWidgets);
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('Water'), findsOneWidget);
    expect(find.text('Exercise'), findsOneWidget);
    expect(find.text('Secondary metrics'), findsOneWidget);
    expect(find.text('Blood Pressure'), findsOneWidget);
  });

}

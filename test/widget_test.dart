import 'package:flutter_test/flutter_test.dart';

import 'package:sanjid_app/main.dart';

void main() {
  testWidgets('Life OS home renders locked product direction', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());

    expect(find.text('Life OS'), findsOneWidget);
    expect(find.text('Personal Life Operating System'), findsOneWidget);
    expect(find.text('Locked product direction'), findsOneWidget);
    expect(find.text('English only'), findsOneWidget);
    expect(find.text('Android first'), findsOneWidget);
    expect(find.text('Offline-first + Firebase sync'), findsOneWidget);
    expect(find.text('Life modules'), findsOneWidget);
    expect(find.text('Coming soon'), findsOneWidget);
    expect(find.text('Update roadmap'), findsOneWidget);
    expect(find.text('Quick Add'), findsOneWidget);
  });
}

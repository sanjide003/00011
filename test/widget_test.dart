import 'package:flutter_test/flutter_test.dart';

import 'package:sanjid_app/main.dart';

void main() {
  testWidgets('Life OS home renders core sections', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeOsApp());

    expect(find.text('Life OS'), findsOneWidget);
    expect(find.text('Personal Life Operating System'), findsOneWidget);
    expect(find.text('Today at a glance'), findsOneWidget);
    expect(find.text('Daily focus'), findsOneWidget);
    expect(find.text('Life modules'), findsOneWidget);
    expect(find.text('Build roadmap'), findsOneWidget);
    expect(find.text('Quick Add'), findsOneWidget);
  });
}

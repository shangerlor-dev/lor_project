import 'package:flutter_test/flutter_test.dart';
import 'package:lor_project/app.dart';

void main() {
  testWidgets('App starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const PuvPassengerCountingApp());

    expect(find.text('Public Utility Vehicle\nPassenger Counting'),
        findsOneWidget);
  });
}
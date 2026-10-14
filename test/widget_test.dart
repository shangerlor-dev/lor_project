
import 'package:flutter_test/flutter_test.dart';
import 'package:lor_project/app.dart';

void main() {
  testWidgets('MyApp displays the login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}

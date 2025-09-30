// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:product_listing_app/main.dart';
import 'package:product_listing_app/core/di/dependency_injection.dart' as di;

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    // Ensure DI is initialized for widget tests
    await di.setupLocator();
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Allow any animations or navigation to settle and let the splash delay finish
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    // If the app builds without throwing exceptions we consider the smoke test passed.
    expect(tester.takeException(), isNull);
  });
}

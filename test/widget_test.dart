import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carbon_footprint_calculator/main.dart';

void main() {
  testWidgets('Carbon Footprint Calculator Test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(MyApp());

    // Verify that the initial screen is displayed
    expect(find.text('Carbon Footprint Calculator'), findsOneWidget);

    // Enter data into text fields
    await tester.enterText(find.byType(TextFormField).at(0), '500');
    await tester.enterText(find.byType(TextFormField).at(1), '100');
    await tester.enterText(find.byType(TextFormField).at(2), '20');
    await tester.enterText(find.byType(TextFormField).at(3), '10');
    await tester.enterText(find.byType(TextFormField).at(4), '15000');
    await tester.enterText(find.byType(TextFormField).at(5), '25');

    // Tap the calculate button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that the result dialog is displayed
    expect(find.text('Your Carbon Footprint Result'), findsOneWidget);
  });
}

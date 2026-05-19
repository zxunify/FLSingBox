// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flsingbox/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    // Set a reasonable screen size to avoid overflow in test environment
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: FlSingBoxApp(),
      ),
    );

    // Verify app renders with navigation
    expect(find.byType(MaterialApp), findsOneWidget);

    // Allow pending timers to complete
    await tester.pumpAndSettle(const Duration(seconds: 1));
  });
}

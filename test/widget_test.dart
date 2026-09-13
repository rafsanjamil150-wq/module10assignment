import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:module10assignment/main.dart';
import 'package:module10assignment/screens/product_list_screen.dart';
import 'package:module10assignment/screens/splash_screen.dart';

void main() {
  testWidgets('App builds and shows splash screen first',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(ProductListScreen), findsNothing);
  });

  testWidgets('Splash screen navigates to product list screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(ProductListScreen), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
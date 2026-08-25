import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:module10assignment/main.dart';

void main() {
  testWidgets('App builds and shows product list screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(Scaffold), findsWidgets);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}

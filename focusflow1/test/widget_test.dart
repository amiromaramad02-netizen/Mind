import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focusflow1/main.dart';

void main() {
  testWidgets('FocusFlow app boots', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FocusFlowApp()),
    );

    await tester.pumpAndSettle();
    expect(find.text('Focus on what matters'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

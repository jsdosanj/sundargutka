import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sundargutka/providers/settings_provider.dart';
import 'package:sundargutka/widgets/vishraam_text.dart';
import 'package:sundargutka/models/verse.dart';

void main() {
  group('Widget tests', () {
    testWidgets('VishraamText renders plain text when no vishraams',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VishraamText(
              text: 'ਸਤਿ ਨਾਮੁ ਕਰਤਾ',
              vishraams: [],
              fontSize: 20,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      );

      expect(find.text('ਸਤਿ ਨਾਮੁ ਕਰਤਾ'), findsOneWidget);
    });

    testWidgets('VishraamText renders RichText when vishraams present',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VishraamText(
              text: 'ਸਤਿ ਨਾਮੁ ਕਰਤਾ',
              vishraams: [
                Vishraam(position: 1, type: 'long'),
              ],
              fontSize: 20,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      );

      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('SettingsProvider can be read via Provider',
        (WidgetTester tester) async {
      final settings = SettingsProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: settings,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final s = context.watch<SettingsProvider>();
                return Text('${s.fontSize}');
              },
            ),
          ),
        ),
      );

      expect(find.text('20.0'), findsOneWidget);
    });
  });
}

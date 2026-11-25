import 'package:ecommerce_app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('shows the CraftyBay splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EcommerceApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      tester
          .widget<MaterialApp>(find.byType(MaterialApp))
          .theme
          ?.textTheme
          .bodyMedium
          ?.fontFamily,
      'Poppins',
    );
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Version 1.0'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigates through all three auth screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EcommerceApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).first,
      'shopper@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Enter OTP Code'), findsOneWidget);
    final otpFields = find.byType(EditableText);
    for (var index = 0; index < 4; index++) {
      expect(
        tester.getSize(find.byKey(ValueKey('otp-box-$index'))),
        const Size(40, 40),
      );
    }

    await tester.tap(find.byKey(const ValueKey('otp-box-0')));
    await tester.pump();
    final boxRect = tester.getRect(find.byKey(const ValueKey('otp-box-0')));
    final editableRect = tester.getRect(otpFields.first);
    expect(editableRect.center.dx, closeTo(boxRect.center.dx, 0.5));
    expect(editableRect.center.dy, closeTo(boxRect.center.dy, 0.5));
    expect(
      tester.widget<EditableText>(otpFields.first).textAlign,
      TextAlign.center,
    );

    for (var index = 0; index < 4; index++) {
      await tester.enterText(otpFields.at(index), '${index + 1}');
    }
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Complete Profile'), findsOneWidget);
    final profileFields = find.byType(TextFormField);
    for (var index = 0; index < 5; index++) {
      await tester.enterText(profileFields.at(index), 'Profile $index');
    }
    await tester.tap(find.text('Complete'));
    await tester.pumpAndSettle();

    expect(find.text('All Categories'), findsOneWidget);
    expect(find.text('Brands'), findsOneWidget);
    expect(find.text('Special'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
  });
}

import 'package:ecommerce_app/presentation/pages/review/view/reviews_screen.dart';
import 'package:ecommerce_app/presentation/pages/review/widgets/review_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('reviews screen shows review cards and add action', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(340, 577);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var addTapped = false;
    await tester.pumpWidget(
      MaterialApp(home: ReviewsScreen(onCreateReview: () => addTapped = true)),
    );

    expect(find.text('Reviews'), findsOneWidget);
    expect(find.text('Reviews (1000)'), findsOneWidget);
    expect(find.byType(ReviewCard), findsNWidgets(4));
    await tester.tap(find.byKey(const ValueKey('bottom-action-icon-button')));

    expect(addTapped, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('submitting a new review adds it to the list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ReviewsScreen()));

    await tester.tap(find.byKey(const ValueKey('bottom-action-icon-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('review-first-name')),
      'Alex',
    );
    await tester.enterText(
      find.byKey(const ValueKey('review-last-name')),
      'Morgan',
    );
    await tester.enterText(
      find.byKey(const ValueKey('review-text')),
      'Excellent quality.',
    );
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Reviews (1001)'), findsOneWidget);
    expect(find.text('Alex Morgan'), findsOneWidget);
    expect(find.text('Excellent quality.'), findsOneWidget);
    expect(find.byType(ReviewCard), findsNWidgets(5));
    expect(tester.takeException(), isNull);
  });
}

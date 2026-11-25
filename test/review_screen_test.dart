import 'package:ecommerce_app/presentation/pages/review/view/create_review_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('review form validates and submits all fields', (
    WidgetTester tester,
  ) async {
    String? submittedFirstName;
    String? submittedLastName;
    String? submittedReview;

    await tester.pumpWidget(
      MaterialApp(
        home: CreateReviewScreen(
          onSubmit: (firstName, lastName, review) {
            submittedFirstName = firstName;
            submittedLastName = lastName;
            submittedReview = review;
          },
        ),
      ),
    );

    expect(find.text('Create Review'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));

    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(find.text('This field is required'), findsNWidgets(3));

    await tester.enterText(
      find.byKey(const ValueKey('review-first-name')),
      '  Alex  ',
    );
    await tester.enterText(
      find.byKey(const ValueKey('review-last-name')),
      '  Morgan  ',
    );
    await tester.enterText(
      find.byKey(const ValueKey('review-text')),
      '  Great product.  ',
    );
    await tester.tap(find.text('Submit'));

    expect(submittedFirstName, 'Alex');
    expect(submittedLastName, 'Morgan');
    expect(submittedReview, 'Great product.');
    expect(tester.takeException(), isNull);
  });
}

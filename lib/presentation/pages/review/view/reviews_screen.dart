import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/pages/review/view/create_review_screen.dart';
import 'package:ecommerce_app/presentation/widgets/bottom_action_bar.dart';
import 'package:ecommerce_app/presentation/pages/review/widgets/review_card.dart';
import 'package:material_ui/material_ui.dart';

const _sampleComment =
    'Reference site about Lorem Ipsum, giving information on its origins, as '
    'well as a random lipsum generator. Reference site about Lorem Ipsum, '
    'giving information on its origins, as well as a random lipsum generator.';

const _sampleReviews = [
  ReviewItem(author: 'Rabbil Hasan', comment: _sampleComment),
  ReviewItem(author: 'Rabbil Hasan', comment: _sampleComment),
  ReviewItem(author: 'Rabbil Hasan', comment: _sampleComment),
  ReviewItem(author: 'Rabbil Hasan', comment: _sampleComment),
];

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({
    this.reviews = _sampleReviews,
    this.reviewCount = 1000,
    this.onBack,
    this.onCreateReview,
    super.key,
  });

  final List<ReviewItem> reviews;
  final int reviewCount;
  final VoidCallback? onBack;
  final VoidCallback? onCreateReview;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late final List<ReviewItem> _reviews;
  late int _reviewCount;

  @override
  void initState() {
    super.initState();
    _reviews = List.of(widget.reviews);
    _reviewCount = widget.reviewCount;
  }

  void _openCreateReview() {
    final onCreateReview = widget.onCreateReview;
    if (onCreateReview != null) {
      onCreateReview();
      return;
    }

    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => CreateReviewScreen(
          onSubmit: (firstName, lastName, comment) {
            setState(() {
              _reviews.insert(
                0,
                ReviewItem(author: '$firstName $lastName', comment: comment),
              );
              _reviewCount++;
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 48,
        flexibleSpace: const Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 2,
            width: double.infinity,
            child: ColoredBox(color: AppColors.primary),
          ),
        ),
        leadingWidth: 32,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
        ),
        titleSpacing: 0,
        title: const Text(
          AppStrings.reviews,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
        itemCount: _reviews.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => ReviewCard(review: _reviews[index]),
      ),
      bottomNavigationBar: BottomActionBar(
        title: '${AppStrings.reviews} ($_reviewCount)',
        actionIcon: Icons.add,
        actionSemanticLabel: AppStrings.addReview,
        onAction: _openCreateReview,
      ),
    );
  }
}

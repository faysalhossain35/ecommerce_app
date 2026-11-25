import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class ReviewItem {
  const ReviewItem({required this.author, required this.comment});

  final String author;
  final String comment;
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({required this.review, super.key});

  final ReviewItem review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.shimmer),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shimmer,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person_outline,
                  color: AppColors.iconInactive,
                  size: 13,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  review.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            review.comment,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 8,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

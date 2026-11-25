import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_primary_button.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_text_field.dart';
import 'package:material_ui/material_ui.dart';

typedef ReviewSubmitCallback = void Function(
  String firstName,
  String lastName,
  String review,
);

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({this.onSubmit, this.onBack, super.key});

  final ReviewSubmitCallback? onSubmit;
  final VoidCallback? onBack;

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    widget.onSubmit?.call(
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
      _reviewController.text.trim(),
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
        leadingWidth: 32,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
        ),
        titleSpacing: 0,
        title: const Text(
          AppStrings.createReview,
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
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 34, 28, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AuthTextField(
                  key: const ValueKey('review-first-name'),
                  hintText: AppStrings.firstName,
                  controller: _firstNameController,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  key: const ValueKey('review-last-name'),
                  hintText: AppStrings.lastName,
                  controller: _lastNameController,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 176,
                  child: TextFormField(
                    key: const ValueKey('review-text'),
                    controller: _reviewController,
                    validator: _requiredValidator,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: AppStrings.writeReview,
                      hintStyle: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 0.7,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 0.7,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AuthPrimaryButton(
                  label: AppStrings.submit,
                  onPressed: _submit,
                  height: 34,
                  fontSize: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }
}

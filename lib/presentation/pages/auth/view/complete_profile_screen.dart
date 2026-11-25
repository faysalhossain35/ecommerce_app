import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_heading.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_logo.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_primary_button.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_text_field.dart';
import 'package:ecommerce_app/presentation/pages/home/view/main_navigation_screen.dart';
import 'package:material_ui/material_ui.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = List.generate(5, (_) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _complete() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const MainNavigationScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fields = [
      (AppStrings.firstName, TextInputType.name, 1),
      (AppStrings.lastName, TextInputType.name, 1),
      (AppStrings.mobile, TextInputType.phone, 1),
      (AppStrings.city, TextInputType.text, 1),
      (AppStrings.shippingAddress, TextInputType.streetAddress, 3),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                const AuthLogo(width: 80),
                const SizedBox(height: 8),
                const AuthHeading(
                  title: AppStrings.completeProfile,
                  subtitle: AppStrings.completeProfileSubtitle,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      for (var index = 0; index < fields.length; index++) ...[
                        AuthTextField(
                          hintText: fields[index].$1,
                          controller: _controllers[index],
                          keyboardType: fields[index].$2,
                          maxLines: fields[index].$3,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.fieldRequired;
                            }
                            return null;
                          },
                        ),
                        //if (index < fields.length - 1)
                        const SizedBox(height: 12),
                      ],
                      const SizedBox(height: 10),
                      AuthPrimaryButton(
                        label: AppStrings.complete,
                        onPressed: _complete,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

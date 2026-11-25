import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/pages/auth/view/enter_otp_screen.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_heading.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_logo.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_primary_button.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_text_field.dart';
import 'package:ecommerce_app/presentation/pages/auth/providers/auth_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({super.key});

  @override
  State<WelcomeBackScreen> createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => EnterOtpScreen(email: _emailController.text.trim()),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => EnterOtpScreen(email: _emailController.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
              child: Column(
                children: [
                  SizedBox(height: 120),
                  const AuthLogo(width: 80),
                  const SizedBox(height: 10),
                  const AuthHeading(
                    title: AppStrings.welcomeBack,
                    subtitle: AppStrings.enterEmailPrompt,
                  ),
                  const SizedBox(height: 14),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthTextField(
                          hintText: AppStrings.emailAddress,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.emailRequired;
                            }
                            if (!value.trim().contains('@') ||
                                !value.trim().contains('.')) {
                              return AppStrings.emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        AuthTextField(
                          hintText: AppStrings.password,
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints.tightFor(
                              width: 32,
                              height: 32,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              size: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.passwordRequired;
                            }
                            if (value.length < 6) {
                              return AppStrings.passwordTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        AuthPrimaryButton(
                          label: AppStrings.next,
                          onPressed: _continue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

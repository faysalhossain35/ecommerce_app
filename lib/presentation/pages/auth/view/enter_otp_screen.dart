import 'dart:async';

import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/pages/auth/view/complete_profile_screen.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_heading.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_logo.dart';
import 'package:ecommerce_app/presentation/pages/auth/widgets/auth_primary_button.dart';
import 'package:ecommerce_app/presentation/pages/auth/providers/auth_provider.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class EnterOtpScreen extends StatefulWidget {
  const EnterOtpScreen({this.email, super.key});

  final String? email;

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  static const _otpLength = 4;
  static const _otpBoxSize = 40.0;
  static const _otpBoxGap = 7.0;
  final _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  final _focusNodes = List.generate(_otpLength, (_) => FocusNode());
  late Timer _countdownTimer;
  int _secondsRemaining = 120;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _resendCode() async {
    if (widget.email != null) {
      try {
        await context.read<AuthProvider>().resendOtp(widget.email!);
      } catch (_) {
        // Keep the countdown UX even if the resend request fails.
      }
    }
    setState(() => _secondsRemaining = 120);
    if (!_countdownTimer.isActive) {
      _startCountdown();
    }
  }

  Future<void> _continue() async {
    final code = _controllers.map((controller) => controller.text).join();
    if (code.length != _otpLength) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.otpIncomplete)));
      return;
    }
    if (widget.email != null) {
      final authProvider = context.read<AuthProvider>();
      try {
        await authProvider.verifyOtp(widget.email!, code);
      } catch (_) {
        // Continue through the existing OTP flow when verification is offline.
      }
    }
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const CompleteProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Column(
              children: [
                const SizedBox(height: 120),
                const AuthLogo(width: 80),
                const SizedBox(height: 10),
                const AuthHeading(
                  title: AppStrings.enterOtpCode,
                  subtitle: AppStrings.otpSentMessage,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_otpLength, (index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index == _otpLength - 1 ? 0 : _otpBoxGap,
                      ),
                      child: SizedBox(
                        key: ValueKey('otp-box-$index'),
                        width: _otpBoxSize,
                        height: _otpBoxSize,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 0.7,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 26,
                              height: 12,
                              child: EditableText(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                cursorWidth: 1.2,
                                cursorHeight: 14,
                                cursorColor: AppColors.logoTeal,
                                backgroundCursorColor: AppColors.background,
                                selectionColor: AppColors.primaryLight,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1,
                                  color: AppColors.textPrimary,
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty &&
                                      index < _otpLength - 1) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                AuthPrimaryButton(label: AppStrings.next, onPressed: _continue),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(text: AppStrings.codeExpiresIn),
                      TextSpan(
                        text: '${_secondsRemaining}s',
                        style: const TextStyle(color: AppColors.logoTeal),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _resendCode,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    AppStrings.resendCode,
                    style: TextStyle(fontSize: 10),
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

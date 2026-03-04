import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/webview_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';


/// Login screen — mobile number input only.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Kick off website preload in the background while the user is on this
    // screen so HomeScreen loads instantly after authentication.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(webViewControllerProvider);
    });
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    ref.read(authProvider.notifier).clearError();

    final mobile = Validators.cleanMobile(_mobileController.text);
    await ref.read(authProvider.notifier).login(mobile);

    if (!mounted) return;
    setState(() => _isLoading = false);

    final authState = ref.read(authProvider);
    if (authState.errorMessage != null) {
      _showError(authState.errorMessage!);
    } else if (authState.otpSessionId != null) {
      Navigator.of(context).pushNamed(
        '/otp',
        arguments: mobile,
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                // Logo
                Center(
                  child: SvgPicture.asset(
                    'assets/svgs/logo.svg',
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 40),

                // Title
                const Text(
                  AppStrings.login,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  AppStrings.loginSubtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 40),

                // Mobile number field
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    hintText: AppStrings.mobileNumber,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16, top: 14, bottom: 14),
                      child: Text(
                        '+91  ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 60),
                  ),
                  validator: Validators.validateMobile,
                ),
                const SizedBox(height: 32),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            AppStrings.login,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign-up link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/signup');
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: AppStrings.noAccount,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: AppStrings.signUp,
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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

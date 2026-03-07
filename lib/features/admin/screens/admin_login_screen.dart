import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpVisible = false;
  bool _isLoading = false;
  String? _error;

  final String _adminMobile = '8420745907';
  final String _adminStaticOtp = '258014';

  @override
  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() => _error = null);
    final mobile = _mobileController.text.trim();

    if (mobile != _adminMobile) {
      setState(() => _error = 'Unauthorised access. This number is not registered as admin.');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Smooth transition
    setState(() {
      _isLoading = false;
      _isOtpVisible = true;
    });
  }

  void _verifyOtp() async {
    setState(() => _error = null);
    final otp = _otpController.text.trim();

    if (otp != _adminStaticOtp) {
      setState(() => _error = 'Invalid administrative code.');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final appwrite = ref.read(appwriteServiceProvider);
      await appwrite.loginAdmin();
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/admin-dashboard');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Show actual error message for easier debugging
        _error = e.toString().contains('AppwriteException') 
          ? e.toString() 
          : 'Failed to establish secure session. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background Aesthetic
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF7800).withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF7800).withOpacity(0.05),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Icon(Icons.chevron_left, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Title Section
                  Text(
                    _isOtpVisible ? 'VERIFY' : 'ADMIN',
                    style: GoogleFonts.montserrat(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 0.9,
                      letterSpacing: -2.0,
                    ),
                  ),
                  Text(
                    _isOtpVisible ? 'ACCESS' : 'PORTAL',
                    style: GoogleFonts.montserrat(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFFFF7800),
                      height: 1.0,
                      letterSpacing: -2.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isOtpVisible 
                      ? 'Please enter the 6-digit administrative code provided to you.'
                      : 'Enter your registered mobile number to proceed to the secure dashboard.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF94A3B8),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Input Section
                  if (!_isOtpVisible) ...[
                    _buildInputLabel('ADMIN MOBILE'),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _mobileController,
                      hint: 'Enter mobile number',
                      icon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ] else ...[
                    _buildInputLabel('SECURE PASSCODE'),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _otpController,
                      hint: 'Enter 6-digit code',
                      icon: Icons.lock_person_rounded,
                      keyboardType: TextInputType.number,
                      isOtp: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                    ),
                  ],

                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: GoogleFonts.inter(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Action Button
                  GestureDetector(
                    onTap: _isLoading ? null : (_isOtpVisible ? _verifyOtp : _handleLogin),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7800),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF7800).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isLoading 
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              _isOtpVisible ? 'VERIFY & ENTER' : 'CONTINUE',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 2.0,
                              ),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: const Color(0xFF64748B),
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool isOtp = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: isOtp,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: const Color(0xFF475569), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFFFF7800), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/service_request_provider.dart';

class ClientDetailsScreen extends ConsumerStatefulWidget {
  const ClientDetailsScreen({super.key});

  @override
  ConsumerState<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends ConsumerState<ClientDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(serviceRequestProvider.notifier).setClientDetails(
          name: _nameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          address: _addressCtrl.text.trim(),
        );
    Navigator.of(context).pushNamed('/schedule');
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Background Ambient Glow (Top Right)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE87C2E).withOpacity(0.2),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // Background Ambient Glow (Bottom Left)
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE87C2E).withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xFF18181B), // zinc-900
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Color(0xFFA1A1AA), size: 20),
                          onPressed: () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Step Indicator
                      // Aya skips a step, so if service is Aya this is Step 2, otherwise it's Step 3.
                      // For visual consistency with your design, we will show "STEP 3/5".
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF27272A), // zinc-800
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'STEP 3/5',
                          style: TextStyle(
                            color: Color(0xFFA1A1AA), // zinc-400
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800, // ExtraBold
                            height: 1.1,
                            color: Colors.white,
                            letterSpacing: -1.0,
                          ),
                          children: [
                            TextSpan(text: 'CLIENT\n'),
                            TextSpan(
                              text: 'DETAILS.',
                              style: TextStyle(color: Color(0xFFE87C2E)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Subtitle
                      const Text(
                        'Please provide your contact information to proceed with the booking.',
                        style: TextStyle(
                          color: Color(0xFFA1A1AA), // zinc-400
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Form Section (Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputGroup(
                            label: 'FULL NAME',
                            child: _buildTextField(
                              controller: _nameCtrl,
                              hintText: 'John Doe',
                              textCapitalization: TextCapitalization.words,
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildInputGroup(
                            label: 'PHONE NUMBER',
                            child: _buildPhoneField(),
                          ),
                          const SizedBox(height: 24),
                          _buildInputGroup(
                            label: 'FULL ADDRESS / LOCATION',
                            child: _buildTextField(
                              controller: _addressCtrl,
                              hintText: 'Enter your full service address',
                              maxLines: 4,
                              minLines: 3,
                              textCapitalization: TextCapitalization.sentences,
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'Address is required' : null,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),

                // Footer Section
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Zero Liability Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414), // surface-dark
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF27272A)), // zinc-800
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE87C2E).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.verified_user_outlined,
                                color: Color(0xFFE87C2E),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ZERO LIABILITY',
                                    style: TextStyle(
                                      color: Color(0xFFE4E4E7), // zinc-200
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Your data is encrypted. We only share necessary details with verified service professionals.',
                                    style: TextStyle(
                                      color: Color(0xFFA1A1AA), // zinc-400
                                      fontSize: 11,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _handleContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE87C2E),
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor: const Color(0xFFE87C2E).withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'CONTINUE',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 20),
                            ],
                          ),
                        ),
                      ),
                      
                      // Home Indicator (Visual only)
                      const SizedBox(height: 32),
                      Container(
                        width: 128,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF27272A),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputGroup({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFA1A1AA), // zinc-400
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required String hintText,
    int? maxLines = 1,
    int? minLines,
    TextEditingController? controller,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF18181B), // zinc-900
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF27272A)), // zinc-800
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        textCapitalization: textCapitalization,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: const Color(0xFFE87C2E),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF52525B)), // zinc-600
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE87C2E)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF18181B), // zinc-900
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF27272A)), // zinc-800
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0xFF27272A)), // zinc-800
              ),
            ),
            child: const Text(
              '+91',
              style: TextStyle(
                color: Color(0xFFA1A1AA), // zinc-400
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Phone is required';
                if (v.trim().length != 10) return 'Enter a valid 10-digit number';
                return null;
              },
              style: const TextStyle(color: Colors.white, fontSize: 16),
              cursorColor: const Color(0xFFE87C2E),
              decoration: const InputDecoration(
                hintText: '98765 43210',
                hintStyle: TextStyle(color: Color(0xFF52525B)), // zinc-600
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

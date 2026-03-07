import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/service_request_provider.dart';

class ServiceTypeScreen extends ConsumerStatefulWidget {
  const ServiceTypeScreen({super.key});

  @override
  ConsumerState<ServiceTypeScreen> createState() => _ServiceTypeScreenState();
}

class _ServiceTypeScreenState extends ConsumerState<ServiceTypeScreen> {
  int? _selectedIndex; // null initially, 0 for Repair, 1 for New

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // background-light
      body: Stack(
        children: [
          // Background Glow Effect
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 0.8,
                  colors: [
                    const Color(0xFFE87D25).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Top Header (Back Button & Step Indicator)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                        ),
                      ),
                      // Header Step Indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Text(
                          'STEP 2/5',
                          style: GoogleFonts.syncopate(
                            color: const Color(0xFFE87D25),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Balance out back button
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Main Title
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.syncopate(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black, // Dark text for light mode
                        height: 1.1,
                      ),
                      children: [
                        const TextSpan(text: 'WHAT TYPE OF\nWORK DO YOU\n'),
                        TextSpan(
                          text: 'NEED?',
                          style: GoogleFonts.syncopate(
                            color: const Color(0xFFE87D25),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Select the nature of service to help us assign the right specialist.',
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Service Cards List
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final selectedService = ref.watch(serviceRequestProvider).service;
                        final isLand = selectedService == 'Land';

                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildCard(
                              index: 0,
                              number: '01',
                              title: isLand ? 'OLD' : 'REPAIR',
                              subtitle: isLand 
                                ? 'Existing land property or resale plots available in the market.'
                                : 'Fixing existing issues, maintenance, or restoration works.',
                              isSelected: _selectedIndex == 0,
                              hideSubheading: isLand,
                            ),
                            const SizedBox(height: 16),
                            _buildCard(
                              index: 1,
                              number: '02',
                              title: 'NEW',
                              subtitle: isLand 
                                ? 'Fresh land purchase, new development projects or original listings.'
                                : 'Fresh installations, construction, or brand new setup projects.',
                              isSelected: _selectedIndex == 1,
                              hideSubheading: isLand,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  
                  // Footer Actions
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _selectedIndex == null
                          ? null
                          : () {
                              final selectedService = ref.read(serviceRequestProvider).service;
                              final isLand = selectedService == 'Land';
                              
                              String type;
                              if (isLand) {
                                type = _selectedIndex == 0 ? 'Old' : 'New';
                              } else {
                                type = _selectedIndex == 0 ? 'Repair' : 'New';
                              }
                              
                              ref.read(serviceRequestProvider.notifier).setType(type);
                              Navigator.of(context).pushNamed('/client-details');
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE87D25),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: _selectedIndex == null ? 0 : 8,
                        shadowColor: const Color(0xFFE87D25).withOpacity(0.4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CONTINUE TO DETAILS',
                            style: GoogleFonts.syncopate(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Branding Footer
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 40, height: 1, color: Colors.black12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'SOMADHAN',
                            style: GoogleFonts.syncopate(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                        Container(width: 40, height: 1, color: Colors.black12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required int index,
    required String number,
    required String title,
    required String subtitle,
    required bool isSelected,
    bool hideSubheading = false,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFF141414), // card-dark
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: const Color(0xFFE87D25), width: 3)
              : Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFE87D25).withOpacity(0.25),
                    blurRadius: 30,
                    spreadRadius: 0,
                  )
                ]
              : [],
        ),
        child: Stack(
          children: [
            // Watermark Number
            Positioned(
              top: -10,
              right: 20,
              child: Text(
                number,
                style: GoogleFonts.syncopate(
                  fontSize: 100,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Card Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!hideSubheading)
                    Text(
                      'SERVICE TYPE',
                      style: GoogleFonts.syncopate(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFFE87D25) : Colors.grey[600],
                        letterSpacing: 1.5,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.syncopate(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[500],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // Selection Checkmark
            if (isSelected)
              Positioned(
                top: 24,
                left: 24,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE87D25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 16, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

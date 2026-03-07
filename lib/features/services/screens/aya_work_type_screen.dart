import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/service_request_provider.dart';

class AyaWorkTypeScreen extends ConsumerStatefulWidget {
  const AyaWorkTypeScreen({super.key});

  @override
  ConsumerState<AyaWorkTypeScreen> createState() => _AyaWorkTypeScreenState();
}

class _AyaWorkTypeScreenState extends ConsumerState<AyaWorkTypeScreen> {
  int _selectedIndex = 1; // Default selected index (Elder Care)

  final List<Map<String, String>> _services = [
    {
      'title': 'CHILD CARE',
      'desc': 'Nanny and babysitting services for your little ones.',
    },
    {
      'title': 'ELDER CARE',
      'desc': 'Dedicated support and companionship for senior citizens.',
    },
    {
      'title': 'PATIENT CARE',
      'desc': 'Professional nursing and post-operative home assistance.',
    },
    {
      'title': 'HOUSE HELP',
      'desc': 'General domestic assistance and housekeeping support.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Top Right Glow
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE87C2E).withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE87C2E).withOpacity(0.05),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          // Bottom Left Glow
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE87C2E).withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE87C2E).withOpacity(0.05),
                    blurRadius: 120,
                    spreadRadius: 60,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: _buildIconButton(Icons.chevron_left),
                      ),
                      Column(
                        children: [
                          Text(
                            'STEP 2 / 5',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              color: const Color(0xFFE87C2E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 96,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF262626),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.4,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE87C2E),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                        child: _buildIconButton(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  
                  // Title
                  Text(
                    'IDENTIFY',
                    style: GoogleFonts.montserrat(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
                  ),
                  Text(
                    'AYA SERVICE',
                    style: GoogleFonts.montserrat(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFFE87C2E),
                      height: 1.1,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'What type of Aya service do you need for your home or facility?',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFA3A3A3),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Options List
                  ...List.generate(_services.length, (index) {
                    return _buildServiceCard(index);
                  }),
                  
                  const SizedBox(height: 24),
                  
                  // Continue Button
                  GestureDetector(
                    onTap: () {
                      final selectedTitle = _services[_selectedIndex]['title']!;
                      ref
                          .read(serviceRequestProvider.notifier)
                          .setAyaType(selectedTitle);
                      Navigator.of(context).pushNamed('/client-details');
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE87C2E),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE87C2E).withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CONTINUE REQUEST',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 2.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Footer Text
                  Center(
                    child: Text(
                      'EXPERT CARE, GUARANTEED TRUST.',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.0,
                        color: const Color(0xFF737373),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Brand Footer
                  const Divider(color: Color(0xFF262626)),
                  const SizedBox(height: 32),
                  Opacity(
                    opacity: 0.4,
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'RESOLUTION · AUTHORITY',
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF262626)),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildServiceCard(int index) {
    final isSelected = _selectedIndex == index;
    final service = _services[index];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFE87C2E) : const Color(0xFF262626),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFE87C2E).withOpacity(0.15),
                    blurRadius: 20,
                  )
                ]
              : [],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Background Number
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.montserrat(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    color: isSelected
                        ? const Color(0xFFE87C2E).withOpacity(0.1)
                        : Colors.white.withOpacity(0.03),
                    height: 1.0,
                  ),
                ),
              ),
            ),
            
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SERVICE TYPE',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: isSelected ? const Color(0xFFE87C2E) : const Color(0xFF737373),
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFFE87C2E),
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  service['title']!,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: isSelected ? const Color(0xFFE87C2E) : Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    service['desc']!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF737373),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

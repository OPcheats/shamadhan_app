import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';

/// Data class for an onboarding page.
class _OnboardingPage {
  final String imageAsset;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}

/// Full-screen photo onboarding with dark gradient overlay.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const Color _primaryColor = Color(0xFFFF6A00);
  static const Color _bgDark = Color(0xFF23170F);

  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      imageAsset: 'assets/images/onboradingscreen1.jpg',
      title: AppStrings.onboarding1Title,
      description: AppStrings.onboarding1Desc,
    ),
    _OnboardingPage(
      imageAsset: 'assets/images/onbaordingscreen2.jpg',
      title: AppStrings.onboarding2Title,
      description: AppStrings.onboarding2Desc,
    ),
    _OnboardingPage(
      imageAsset: 'assets/images/onboardingscreen3.jpg',
      title: AppStrings.onboarding3Title,
      description: AppStrings.onboarding3Desc,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyHasSeenOnboarding, true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: Stack(
        children: [
          // --- PageView of full-screen background images ---
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return Image.asset(
                _pages[index].imageAsset,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          // --- Dark gradient overlay (top darker → transparent → dark bottom) ---
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.transparent,
                    Colors.black.withOpacity(0.65),
                    Colors.black.withOpacity(0.97),
                  ],
                  stops: const [0.0, 0.30, 0.62, 1.0],
                ),
              ),
            ),
          ),

          // --- UI Content ---
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GestureDetector(
                      onTap: _completeOnboarding,
                      child: Text(
                        AppStrings.skip,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Bottom text content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title (animated cross-fade between pages)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _pages[_currentPage].title,
                          key: ValueKey<int>(_currentPage),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Description
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _pages[_currentPage].description,
                          key: ValueKey<int>(_currentPage + 100),
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 16,
                            height: 1.625,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Dot indicators
                      Row(
                        children: List.generate(_pages.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: _buildDot(isActive: index == _currentPage),
                          );
                        }),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),

                // Continue / Get Started button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(48),
                      ),
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.25),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == _pages.length - 1
                              ? AppStrings.getStarted
                              : 'Continue',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 24 : 6,
      decoration: BoxDecoration(
        color: isActive ? _primaryColor : _primaryColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

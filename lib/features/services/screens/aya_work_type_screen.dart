import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../providers/service_request_provider.dart';

const _ayaOptions = [
  (
    label: 'Child Care',
    description: 'Nanny, babysitting, and infant care',
    icon: Icons.child_care_rounded,
  ),
  (
    label: 'Elder Care',
    description: 'Assistance and care for senior family members',
    icon: Icons.elderly_rounded,
  ),
  (
    label: 'Patient Care',
    description: 'Post-surgery or illness recovery support',
    icon: Icons.medical_services_rounded,
  ),
  (
    label: 'House Help',
    description: 'Cooking, cleaning, and household assistance',
    icon: Icons.home_rounded,
  ),
];

class AyaWorkTypeScreen extends ConsumerStatefulWidget {
  const AyaWorkTypeScreen({super.key});

  @override
  ConsumerState<AyaWorkTypeScreen> createState() => _AyaWorkTypeScreenState();
}

class _AyaWorkTypeScreenState extends ConsumerState<AyaWorkTypeScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Aya Service',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What type of Aya service do you need?',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // Options
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _ayaOptions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final option = _ayaOptions[index];
                  final isSelected = _selected == option.label;
                  return _AyaOptionCard(
                    label: option.label,
                    description: option.description,
                    icon: option.icon,
                    isSelected: isSelected,
                    onTap: () => setState(() => _selected = option.label),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Premium CTA button
            GestureDetector(
              onTap: _selected == null
                  ? null
                  : () {
                      ref
                          .read(serviceRequestProvider.notifier)
                          .setAyaType(_selected!);
                      Navigator.of(context).pushNamed('/client-details');
                    },
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _selected != null ? AppColors.shadowGlow : null,
                  color: _selected != null ? AppColors.accent : AppColors.surfaceLight,
                ),
                child: Stack(
                  children: [
                    if (_selected != null)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.15),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.4],
                            ),
                          ),
                        ),
                      ),
                    Center(
                      child: Text(
                        'CONTINUE',
                        style: TextStyle(
                          color: _selected == null ? AppColors.textHint : Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyaOptionCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AyaOptionCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.12)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.surfaceLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? AppColors.accentGradient
                    : const LinearGradient(
                        colors: [AppColors.surfaceLight, AppColors.surfaceLight],
                      ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color:
                          isSelected ? AppColors.accent : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.accent, size: 24),
          ],
        ),
      ),
    );
  }
}

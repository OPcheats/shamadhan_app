import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';

class AdminRequestDetailScreen extends StatelessWidget {
  const AdminRequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final id = data['\$id'] as String? ?? '—';
    final clientName = data['client_name'] as String? ?? '—';
    final phone = data['phone'] as String? ?? '—';
    final service = data['service'] as String? ?? '—';
    final serviceType = data['service_type'] as String? ?? '';
    final ayaType = data['aya_type'] as String? ?? '';
    final address = data['address'] as String? ?? '—';
    final date = data['preferred_date'] as String? ?? '—';
    final time = data['preferred_time'] as String? ?? '—';
    final notes = data['notes'] as String? ?? '';
    final createdAt = data['\$createdAt'] as String? ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Request Detail',
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client summary header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        clientName.isNotEmpty
                            ? clientName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          service,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Detail card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: AppColors.surfaceLight, width: 1),
              ),
              child: Column(
                children: [
                  _header('Request Information'),
                  _row(Icons.handyman_outlined, 'Service', service),
                  if (serviceType.isNotEmpty)
                    _row(Icons.build_circle_outlined, 'Service Type',
                        serviceType),
                  if (ayaType.isNotEmpty)
                    _row(Icons.child_care_rounded, 'Aya Type', ayaType),
                  _divider(),
                  _row(Icons.location_on_outlined, 'Address', address),
                  _divider(),
                  _row(Icons.calendar_today_outlined, 'Preferred Date', date),
                  _row(Icons.access_time_rounded, 'Preferred Time', time),
                  if (notes.isNotEmpty) ...[
                    _divider(),
                    _row(Icons.notes_rounded, 'Notes', notes),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Request ID card
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: AppColors.surfaceLight, width: 1),
              ),
              child: Column(
                children: [
                  _header('Technical Info'),
                  GestureDetector(
                    onLongPress: () {
                      Clipboard.setData(ClipboardData(text: id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Request ID copied'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: _row(Icons.fingerprint_rounded, 'Request ID', id,
                        mono: true),
                  ),
                  if (createdAt.isNotEmpty)
                    _row(Icons.schedule_rounded, 'Created At',
                        createdAt.length > 19
                            ? createdAt.substring(0, 19).replaceAll('T', ' ')
                            : createdAt),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Long-press Request ID to copy',
              style: TextStyle(
                  color: AppColors.textHint, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(String title) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.surfaceLight, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );

  Widget _row(IconData icon, String label, String value,
          {bool mono = false}) =>
      Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.accent, size: 18),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value.isEmpty ? '—' : value,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: mono ? 12 : 14.5,
                      fontWeight: FontWeight.w500,
                      fontFamily: mono ? 'monospace' : null,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _divider() => const Divider(
        color: AppColors.surfaceLight,
        height: 1,
        thickness: 1,
        indent: 20,
        endIndent: 20,
      );
}

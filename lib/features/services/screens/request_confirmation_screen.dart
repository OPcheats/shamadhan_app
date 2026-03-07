import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/service_request_provider.dart';

class RequestConfirmationScreen extends ConsumerWidget {
  const RequestConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read the current state from Riverpod to show dynamic data
    final request = ref.watch(serviceRequestProvider);
    
    // Safety fallback logic for null types/values just in case
    final serviceName = request.service.isEmpty ? 'UNKNOWN' : request.service;
    final clientName = request.clientName.isEmpty ? 'USER' : request.clientName;
    final clientPhone = request.phone.isEmpty ? 'XXX XXX XXXX' : request.phone;
    final clientAddress = request.address.isEmpty ? 'UNKNOWN ADDRESS' : request.address;
    final prefDate = request.preferredDate.isEmpty ? 'N/A' : request.preferredDate;
    final prefTime = request.preferredTime.isEmpty ? 'N/A' : request.preferredTime;
    // Combining service display text (Aya - Elder Care, Land - New, etc.)
    String serviceDisplay = serviceName;
    if (request.type.isNotEmpty) serviceDisplay += ' - ${request.type}';
    if (request.ayaType.isNotEmpty) serviceDisplay += ' - ${request.ayaType}';
    serviceDisplay = serviceDisplay.toUpperCase();
    final finalNotes = request.notes.isEmpty ? 'No additional notes provided.' : '"${request.notes}"';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Premium Glow Background
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
                    const Color(0xFFE67E22).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildTitleSection(),
                const SizedBox(height: 30),
                Expanded(child: _buildConfirmationCard(
                  name: clientName,
                  service: serviceDisplay,
                  phone: '+91 $clientPhone',
                  time: '$prefDate, $prefTime',
                  address: clientAddress,
                  notes: finalNotes,
                )),
                _buildFooter(context, ref),
                const SizedBox(height: 10), // Bottom handle area
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.grey),
            onPressed: () => Navigator.of(context).pop(), // Support back navigation just in case
          ),
          Text(
            'STEP 5/5',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: const Color(0xFFE67E22),
            ),
          ),
          const SizedBox(width: 40), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REQUEST\nRECEIVED.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              height: 1.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your request before opening WhatsApp.',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationCard({
    required String name,
    required String service,
    required String phone,
    required String time,
    required String address,
    required String notes,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF262626)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Watermark
            Positioned(
              top: 16,
              right: 16,
              child: Text(
                'CONFIRM',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 80,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Client Name'),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Service Requested'),
                    const SizedBox(height: 4),
                    Text(
                      service,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Phone Number'),
                              const SizedBox(height: 4),
                              Text(
                                phone,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Preferred Time'),
                              const SizedBox(height: 4),
                              Text(
                                time,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Service Address'),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Additional Notes'),
                          const SizedBox(height: 4),
                          Text(
                            notes,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
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

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user, size: 12, color: Color(0xFFE67E22)),
              const SizedBox(width: 8),
              Text(
                'SECURED BY SOMADHAN SYSTEMS',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _WhatsAppButton(ref: ref),
          const SizedBox(height: 16),
          Text(
            'A SOMADHAN REPRESENTATIVE WILL RESPOND SHORTLY',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
        color: const Color(0xFFE67E22),
      ),
    );
  }
}

// ── WhatsApp Button Integration ──

class _WhatsAppButton extends StatefulWidget {
  final WidgetRef ref;
  const _WhatsAppButton({required this.ref});

  @override
  State<_WhatsAppButton> createState() => _WhatsAppButtonState();
}

class _WhatsAppButtonState extends State<_WhatsAppButton> {
  bool _launching = false;

  Future<void> _openWhatsApp() async {
    setState(() => _launching = true);
    await widget.ref.read(submitProvider.notifier).launchWhatsApp();
    if (!mounted) return;
    setState(() => _launching = false);

    // Clear request state and go to home
    widget.ref.read(serviceRequestProvider.notifier).reset();
    widget.ref.read(submitProvider.notifier).reset();
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: _launching ? null : _openWhatsApp,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE67E22),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFE67E22).withOpacity(0.5),
          elevation: 10,
          shadowColor: const Color(0xFFE67E22).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _launching
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'OPEN WHATSAPP CHAT',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

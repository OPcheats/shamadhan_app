import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/service_request_provider.dart';

class ServiceData {
  final String id;
  final String name;
  final IconData icon;

  const ServiceData({
    required this.id,
    required this.name,
    required this.icon,
  });
}

final List<ServiceData> services = [
  const ServiceData(id: '01', name: 'Mason', icon: Icons.construction),
  const ServiceData(id: '02', name: 'Carpenter', icon: Icons.handyman),
  const ServiceData(id: '03', name: 'Marble', icon: Icons.grid_view),
  const ServiceData(id: '04', name: 'Grill', icon: Icons.fence),
  const ServiceData(id: '05', name: 'Electrician', icon: Icons.bolt),
  const ServiceData(id: '06', name: 'Plumber', icon: Icons.water_drop),
  const ServiceData(id: '07', name: 'Paint', icon: Icons.format_paint),
  const ServiceData(id: '08', name: 'Modular Kitchen', icon: Icons.kitchen),
  const ServiceData(id: '09', name: 'False Ceiling', icon: Icons.layers),
  const ServiceData(id: '10', name: 'Any Event', icon: Icons.celebration),
  const ServiceData(id: '11', name: 'Land', icon: Icons.landscape),
  const ServiceData(id: '12', name: 'Aya', icon: Icons.medical_services),
  const ServiceData(id: '13', name: 'AC Repair', icon: Icons.ac_unit),
];

class ServiceListScreen extends ConsumerWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconButton(
                    Icons.arrow_back_ios_new,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Column(
                    children: [
                      Text(
                        'STEP 1 OF 5',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          color: const Color(0xFFE8762E),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF262626),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 48 * 0.2,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8762E),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildIconButton(Icons.help_outline),
                ],
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.montserrat(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          height: 1.0,
                          color: Colors.white,
                        ),
                        children: const [
                          TextSpan(text: 'SELECT\n'),
                          TextSpan(
                            text: 'SERVICE',
                            style: TextStyle(color: Color(0xFFE8762E)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'What do you need help with today?',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return ServiceCard(
                    service: services[index],
                    onTap: () {
                      ref.read(serviceRequestProvider.notifier).setService(services[index].name);
                      // Aya has a special flow — skip Service Type screen
                      if (services[index].name == 'Aya') {
                        Navigator.of(context).pushNamed('/aya-work-type');
                      } else {
                        Navigator.of(context).pushNamed('/service-type');
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF262626)),
        ),
        child: Icon(icon, color: Colors.grey[400], size: 20),
      ),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final ServiceData service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key, 
    required this.service,
    required this.onTap,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.04,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141414),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF262626)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8762E).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.service.icon,
                        color: const Color(0xFFE8762E),
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      widget.service.name.toUpperCase(),
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Text(
                  widget.service.id,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

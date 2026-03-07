import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_provider.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  String _selectedFilter = 'ALL TASKS';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(adminRequestsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.refresh(adminRequestsProvider),
        backgroundColor: Colors.white,
        elevation: 12,
        tooltip: 'Refresh Requests',
        child: const Icon(Icons.refresh, color: Color(0xFF0F172A)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 80,
            titleSpacing: 20,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A).withOpacity(0.8),
                    border: Border(
                      bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                ),
              ),
            ),
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Search client, phone or service...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim().toLowerCase();
                      });
                    },
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'INTERNAL PORTAL',
                        style: TextStyle(
                          color: Color(0xFFE87C2E),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ADMIN REQUESTS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Center(
                  child: _buildIconButton(
                    _isSearching ? Icons.close : Icons.search,
                    onTap: () {
                      setState(() {
                        if (_isSearching) {
                          _isSearching = false;
                          _searchController.clear();
                          _searchQuery = '';
                        } else {
                          _isSearching = true;
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildFilterChip('ALL TASKS'),
                      const SizedBox(width: 8),
                      _buildFilterChip('PENDING'),
                      const SizedBox(width: 8),
                      _buildFilterChip('ASSIGNED'),
                      const SizedBox(width: 8),
                      _buildFilterChip('COMPLETED'),
                    ],
                  ),
                ),
              ),
            ),
          ),

          requestsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFE87C2E)),
              ),
            ),
            error: (err, _) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Could not load requests.\n$err',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => ref.refresh(adminRequestsProvider),
                      child: const Text('Retry', style: TextStyle(color: Color(0xFFE87C2E))),
                    ),
                  ],
                ),
              ),
            ),
            data: (requests) {
              // Filter requests based on selected chip and search query
              final filteredRequests = requests.where((r) {
                // Status Filter
                bool matchesStatus = true;
                if (_selectedFilter != 'ALL TASKS') {
                  final status = (r['status'] as String? ?? 'PENDING').toUpperCase();
                  matchesStatus = (status == _selectedFilter);
                }

                if (!matchesStatus) return false;

                // Search Filter
                if (_searchQuery.isEmpty) return true;

                final name = (r['client_name'] as String? ?? '').toLowerCase();
                final phone = (r['phone'] as String? ?? '').toLowerCase();
                final service = (r['service'] as String? ?? '').toLowerCase();

                return name.contains(_searchQuery) || 
                       phone.contains(_searchQuery) || 
                       service.contains(_searchQuery);
              }).toList();

              if (filteredRequests.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inbox_rounded, color: Color(0xFF475569), size: 56),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                            ? 'No matches for "$_searchQuery"'
                            : (_selectedFilter == 'ALL TASKS' 
                                ? 'No service requests yet.' 
                                : 'No $_selectedFilter requests found.'),
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedFilter,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          'TOTAL: ${filteredRequests.length}',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...filteredRequests.map((r) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildDynamicRequestCard(context, r),
                      );
                    }),
                    const SizedBox(height: 48),
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 32,
                          fit: BoxFit.contain,
                          color: Colors.white.withOpacity(0.9),
                          colorBlendMode: BlendMode.srcIn,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'SYSTEM PILLAR: ABSOLUTE CONTROL',
                          style: TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3.0,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 48,
                          height: 2,
                          color: const Color(0xFFE87C2E).withOpacity(0.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                  ]),
                ),
              );
            },
          ),
        ],
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
          color: const Color(0xFF161616),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.notifications, color: Color(0xFFE87C2E), size: 20),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0A0A0A), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE87C2E) : const Color(0xFF161616),
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? null : Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicRequestCard(BuildContext context, Map<String, dynamic> data) {
    final clientName = data['client_name'] as String? ?? '—';
    final service = data['service'] as String? ?? '—';
    final phone = data['phone'] as String? ?? '—';
    final date = data['preferred_date'] as String? ?? '—';
    final statusVal = (data['status'] as String? ?? 'NEW').toUpperCase();
    
    // Status color mapping
    Color statusColor = const Color(0xFF4ADE80); // Default NEW (Green)
    Color statusBgColor = const Color(0xFF14532D).withOpacity(0.3);

    if (statusVal == 'ASSIGNED') {
      statusColor = const Color(0xFF60A5FA); // Blue
      statusBgColor = const Color(0xFF1E3A8A).withOpacity(0.3);
    } else if (statusVal == 'COMPLETED') {
      statusColor = const Color(0xFF4ADE80); // Green
      statusBgColor = const Color(0xFF14532D).withOpacity(0.4);
    } else if (statusVal == 'QUOTED') {
      statusColor = const Color(0xFFFBBF24); // Yellow
      statusBgColor = const Color(0xFF78350F).withOpacity(0.3);
    }

    // Dynamic icon logic
    IconData icon = Icons.handyman;
    final svcLower = service.toLowerCase();
    if (svcLower.contains('carpenter')) icon = Icons.carpenter;
    else if (svcLower.contains('aya')) icon = Icons.child_care;
    else if (svcLower.contains('electrician')) icon = Icons.bolt;
    else if (svcLower.contains('kitchen')) icon = Icons.kitchen;
    else if (svcLower.contains('plumber')) icon = Icons.water_drop;
    else if (svcLower.contains('ac')) icon = Icons.ac_unit;
    else if (svcLower.contains('land')) icon = Icons.landscape;

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/admin-request-detail', arguments: data),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161616),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Icon(icon, color: const Color(0xFFE87C2E)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFE87C2E),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        clientName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusVal.replaceAll('_', ' '),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CONTACT',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Color(0xFF94A3B8), size: 14),
                            const SizedBox(width: 8),
                            Text(
                              phone,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'REQUESTED DATE',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Color(0xFF94A3B8), size: 14),
                            const SizedBox(width: 8),
                            Text(
                              date,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/admin-request-detail', arguments: data),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'VIEW DETAILS',
                        style: TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0A0A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: const Icon(Icons.more_horiz, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

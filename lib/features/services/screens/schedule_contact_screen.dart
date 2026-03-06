import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/service_request_provider.dart';

class ScheduleContactScreen extends ConsumerStatefulWidget {
  const ScheduleContactScreen({super.key});

  @override
  ConsumerState<ScheduleContactScreen> createState() => _ScheduleContactScreenState();
}

class _ScheduleContactScreenState extends ConsumerState<ScheduleContactScreen> {
  // State for selections
  int? _selectedDateIndex;
  int? _selectedTimeIndex;
  
  final _notesCtrl = TextEditingController();
  bool _submitted = false;

  // Data
  final List<String> _dates = ['Today', 'Tomorrow', 'Day After'];
  final List<String> _times = ['10:00 AM', '12:00 PM', '03:00 PM', '06:00 PM'];

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() => _submitted = true);
    
    if (_selectedDateIndex == null || _selectedTimeIndex == null) {
      return;
    }

    ref.read(serviceRequestProvider.notifier).setSchedule(
          date: _dates[_selectedDateIndex!],
          time: _times[_selectedTimeIndex!],
          notes: _notesCtrl.text.trim(),
        );

    await ref.read(submitProvider.notifier).saveToAppwrite();

    if (!mounted) return;

    final state = ref.read(submitProvider);

    if (state.status == SubmitStatus.success) {
      Navigator.of(context).pushNamed('/request-confirmation');
    } else if (state.status == SubmitStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.error ?? 'Unknown error'}')),
      );
      ref.read(submitProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFEC7F13);
    final isLoading = ref.watch(submitProvider).status == SubmitStatus.loading;
    
    // Get location from the provider if the user filled it in the previous step
    final requestState = ref.watch(serviceRequestProvider);
    final userLocation = (requestState.address.isEmpty) 
        ? 'No address provided' 
        : requestState.address;

    return Scaffold(
      backgroundColor: const Color(0xFF221910), // background-dark
      // Header
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            alignment: Alignment.center,
            child: const Icon(Icons.arrow_back, color: primaryColor),
          ),
        ),
        title: const Text(
          'Schedule & Contact',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: primaryColor.withOpacity(0.1),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1: Select Date
                  _buildSectionTitle(Icons.calendar_today, 'Select Date', primaryColor),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_dates.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildDateButton(
                            text: _dates[index],
                            isSelected: _selectedDateIndex == index,
                            onTap: () => setState(() => _selectedDateIndex = index),
                            primaryColor: primaryColor,
                          ),
                        );
                      }),
                    ),
                  ),
                  if (_submitted && _selectedDateIndex == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Please select a date',
                          style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                    ),

                  const SizedBox(height: 32),

                  // Section 2: Select Time
                  _buildSectionTitle(Icons.schedule, 'Select Time', primaryColor),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 3.5,
                    ),
                    itemCount: _times.length,
                    itemBuilder: (context, index) {
                      return _buildTimeButton(
                        text: _times[index],
                        isSelected: _selectedTimeIndex == index,
                        onTap: () => setState(() => _selectedTimeIndex = index),
                        primaryColor: primaryColor,
                      );
                    },
                  ),
                  if (_submitted && _selectedTimeIndex == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Please select a time',
                          style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                    ),

                  const SizedBox(height: 32),

                  // Section 3: Notes
                  _buildSectionTitle(Icons.description_outlined, 'Notes / Brief description of work', primaryColor),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withOpacity(0.2)),
                    ),
                    child: TextField(
                      controller: _notesCtrl,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'E.g. I have a water leak in the kitchen cabinet...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Section 4: Location
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.location_on, color: primaryColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SERVICE LOCATION',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userLocation,
                                style: const TextStyle(
                                  color: Colors.white, // Slate 300 equivalent
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
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
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF221910),
              border: Border(
                top: BorderSide(color: primaryColor.withOpacity(0.1)),
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: primaryColor.withOpacity(0.5),
                  elevation: 8,
                  shadowColor: primaryColor.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading)
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    else ...[
                      const Text(
                        'SUBMIT REQUEST',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.send, size: 20),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDateButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: primaryColor.withOpacity(0.2)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

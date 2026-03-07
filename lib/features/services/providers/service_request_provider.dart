import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/service_request_model.dart';

// ── Submission state ────────────────────────────────────────────────────────

enum SubmitStatus { idle, loading, success, error }

class SubmitState {
  final SubmitStatus status;
  final String? error;
  const SubmitState({this.status = SubmitStatus.idle, this.error});
}

// ── Request data notifier ───────────────────────────────────────────────────

class ServiceRequestNotifier extends StateNotifier<ServiceRequestModel> {
  ServiceRequestNotifier() : super(const ServiceRequestModel());

  void setService(String service) => state = state.copyWith(
        service: service,
        type: '', // Clear type when service changes
        ayaType: '', // Clear ayaType when service changes
      );
  void setType(String type) => state = state.copyWith(type: type);
  void setAyaType(String ayaType) => state = state.copyWith(ayaType: ayaType);
  void setClientDetails({
    required String name,
    required String phone,
    required String address,
  }) =>
      state = state.copyWith(clientName: name, phone: phone, address: address);
  void setSchedule({
    required String date,
    required String time,
    String notes = '',
  }) =>
      state = state.copyWith(preferredDate: date, preferredTime: time, notes: notes);

  void reset() => state = const ServiceRequestModel();
}

final serviceRequestProvider =
    StateNotifierProvider<ServiceRequestNotifier, ServiceRequestModel>(
  (ref) => ServiceRequestNotifier(),
);

// ── Submission notifier ─────────────────────────────────────────────────────

class SubmitNotifier extends StateNotifier<SubmitState> {
  final Ref _ref;
  SubmitNotifier(this._ref) : super(const SubmitState());

  /// Step 1: Save the request to Appwrite.
  Future<void> saveToAppwrite() async {
    state = const SubmitState(status: SubmitStatus.loading);
    final request = _ref.read(serviceRequestProvider);
    try {
      final appwriteService = _ref.read(appwriteServiceProvider);
      await appwriteService.saveServiceRequest(request.toJson());
      state = const SubmitState(status: SubmitStatus.success);
    } catch (e) {
      log('Save error: $e');
      state = SubmitState(status: SubmitStatus.error, error: e.toString());
    }
  }

  /// Step 2: Build the WhatsApp message and open the app.
  Future<void> launchWhatsApp() async {
    final request = _ref.read(serviceRequestProvider);

    final ayaLine = request.ayaType.isNotEmpty
        ? '\nAya Type: ${request.ayaType}'
        : '';
    final typeLine = request.type.isNotEmpty
        ? '\nType: ${request.type}'
        : '';

    final message = '''
*Somadhan - New Service Request*

Client Name: ${request.clientName}
Phone: ${request.phone}
Service: ${request.service}$typeLine$ayaLine
Address: ${request.address}
Time: ${request.preferredDate} at ${request.preferredTime}
Notes: ${request.notes.isEmpty ? 'N/A' : request.notes}
'''.trim();

    final encoded = Uri.encodeComponent(message);
    final number = AppConstants.whatsappBusinessNumber;
    final waUrl = Uri.parse('https://wa.me/$number?text=$encoded');

    try {
      if (await canLaunchUrl(waUrl)) {
        await launchUrl(waUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      log('WhatsApp launch error: $e');
    }
  }

  void reset() => state = const SubmitState();
}

final submitProvider =
    StateNotifierProvider<SubmitNotifier, SubmitState>((ref) {
  return SubmitNotifier(ref);
});

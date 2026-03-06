import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';

/// Provider that fetches all service requests from Appwrite.
/// Returns a list of document data maps.
final adminRequestsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final appwriteService = ref.read(appwriteServiceProvider);
  return appwriteService.listServiceRequests();
});

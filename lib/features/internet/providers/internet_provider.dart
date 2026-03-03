import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Internet connectivity status.
enum InternetStatus { connected, disconnected, checking }

/// Notifier that monitors real internet connectivity (not just network type).
class InternetNotifier extends StateNotifier<InternetStatus> {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  InternetNotifier() : super(InternetStatus.checking) {
    _init();
  }

  void _init() {
    // Initial check
    _checkConnectivity();

    // Listen to connectivity changes
    _subscription = Connectivity().onConnectivityChanged.listen((_) {
      _checkConnectivity();
    });
  }

  /// Actually ping a server to confirm real internet access.
  Future<void> _checkConnectivity() async {
    state = InternetStatus.checking;
    try {
      final result = await Connectivity().checkConnectivity();

      // No network interface at all
      if (result.contains(ConnectivityResult.none) || result.isEmpty) {
        state = InternetStatus.disconnected;
        return;
      }

      // Has network interface — verify actual internet access
      final hasInternet = await _hasRealInternet();
      state = hasInternet
          ? InternetStatus.connected
          : InternetStatus.disconnected;
    } catch (_) {
      state = InternetStatus.disconnected;
    }
  }

  /// Ping Google to verify real internet access.
  Future<bool> _hasRealInternet() async {
    try {
      final response = await http
          .head(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Manual retry from NoInternetScreen.
  Future<void> retry() async {
    await _checkConnectivity();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Provider for internet connectivity status.
final internetProvider =
    StateNotifierProvider<InternetNotifier, InternetStatus>((ref) {
  return InternetNotifier();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/app_constants.dart';

// ─── Reactive state ───────────────────────────────────────────────────────────

/// `true` while the website page is loading.
final webViewLoadingProvider = StateProvider<bool>((ref) => true);

/// `true` when the last page load ended with a resource error.
final webViewErrorProvider = StateProvider<bool>((ref) => false);

// ─── Controller ───────────────────────────────────────────────────────────────

/// Single, long-lived [WebViewController] shared across the whole app.
///
/// Reading this provider from any auth screen (login / signup / OTP) kicks off
/// the background page-load so that [HomeScreen] shows an already-loaded site.
final webViewControllerProvider = Provider<WebViewController>((ref) {
  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) {
          ref.read(webViewErrorProvider.notifier).state = false;
          ref.read(webViewLoadingProvider.notifier).state = true;
        },
        onPageFinished: (_) {
          ref.read(webViewLoadingProvider.notifier).state = false;
        },
        onWebResourceError: (_) {
          ref.read(webViewLoadingProvider.notifier).state = false;
          ref.read(webViewErrorProvider.notifier).state = true;
        },
        onNavigationRequest: (request) {
          if (!request.url.startsWith('https://')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..clearCache()
    ..loadRequest(Uri.parse(AppConstants.homeWebUrl));

  return controller;
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/webview_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';

/// Home screen — full-screen WebView with a blended floating user icon.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Reload the WebView when the app comes back to the foreground.
  /// This fixes the black screen that appears after the app is minimised
  /// and reopened on Android.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final controller = ref.read(webViewControllerProvider);
      controller.reload();
    }
  }

  // ── Profile modal ─────────────────────────────────────────────────────────

  void _showProfileModal() {
    final userName = ref.read(authProvider).user?.fullName ?? 'User';

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            // Avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              userName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text(AppStrings.logout),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> _handleLogout(BuildContext sheetCtx) async {
    Navigator.of(sheetCtx).pop();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(AppStrings.logout,
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(AppStrings.logoutConfirm,
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(AppStrings.cancel,
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(AppStrings.yes,
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(webViewControllerProvider);

    // Watch reactive loading / error state driven by NavigationDelegate
    final isLoading = ref.watch(webViewLoadingProvider);
    final hasError  = ref.watch(webViewErrorProvider);

    final topPadding = MediaQuery.of(context).padding.top;
    const double brandTextWidth = 158.0;
    const double iconTopOffset  = 18.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── WebView (edge-to-edge, always present so platform view persists)
          Opacity(
            opacity: hasError ? 0.0 : 1.0,
            child: WebViewWidget(controller: controller),
          ),

          // ── Error state ───────────────────────────────────────────────────
          if (hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.pageLoadError,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(webViewErrorProvider.notifier).state = false;
                      ref.read(webViewLoadingProvider.notifier).state = true;
                      controller.reload();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text(AppStrings.retry),
                  ),
                ],
              ),
            ),

          // ── Loading overlay ────────────────────────────────────────────────
          // IgnorePointer when not loading so touches pass through to the
          // WebView — this was the root cause of "buttons not working".
          if (isLoading && !hasError)
            IgnorePointer(
              child: Container(
                color: AppColors.background,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                    color: AppColors.accent),
              ),
            ),

          // ── Floating user icon ─────────────────────────────────────────────
          Positioned(
            top: topPadding + iconTopOffset,
            left: brandTextWidth,
            child: GestureDetector(
              onTap: _showProfileModal,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox(
                width: 40,
                height: 36,
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

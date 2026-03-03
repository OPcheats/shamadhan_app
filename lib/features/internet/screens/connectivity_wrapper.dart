import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/internet_provider.dart';
import 'no_internet_screen.dart';

/// Wrapper widget that monitors internet connectivity.
/// Shows NoInternetScreen overlay when disconnected.
class ConnectivityWrapper extends ConsumerWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internetStatus = ref.watch(internetProvider);

    return Stack(
      children: [
        child,
        if (internetStatus == InternetStatus.disconnected)
          Positioned.fill(
            child: NoInternetScreen(
              onRetry: () {
                ref.read(internetProvider.notifier).retry();
              },
            ),
          ),
      ],
    );
  }
}

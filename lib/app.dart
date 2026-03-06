import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/screens/splash_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/auth/screens/otp_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/internet/screens/no_internet_screen.dart';
import 'features/internet/screens/connectivity_wrapper.dart';
import 'features/services/screens/service_list_screen.dart';
import 'features/services/screens/service_type_screen.dart';
import 'features/services/screens/aya_work_type_screen.dart';
import 'features/services/screens/client_details_screen.dart';
import 'features/services/screens/schedule_contact_screen.dart';
import 'features/services/screens/request_confirmation_screen.dart';
import 'features/admin/screens/admin_login_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/admin/screens/admin_request_detail_screen.dart';

/// Root MaterialApp widget.
class ShamadhanApp extends StatelessWidget {
  const ShamadhanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shamadhan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      onGenerateRoute: _onGenerateRoute,
      builder: (context, child) {
        // Wrap entire app in ConnectivityWrapper
        return ConnectivityWrapper(child: child ?? const SizedBox.shrink());
      },
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    Widget page;

    switch (settings.name) {
      case '/splash':
        page = const SplashScreen();
        break;
      case '/onboarding':
        page = const OnboardingScreen();
        break;
      case '/login':
        page = const LoginScreen();
        break;
      case '/signup':
        page = const SignupScreen();
        break;
      case '/otp':
        final mobile = settings.arguments as String? ?? '';
        page = OtpScreen(mobileNumber: mobile);
        break;
      case '/home':
        page = const HomeScreen();
        break;

      // ── Service flow ────────────────────────────────────────────────────
      case '/service-list':
        page = const ServiceListScreen();
        break;
      case '/service-type':
        page = const ServiceTypeScreen();
        break;
      case '/aya-work-type':
        page = const AyaWorkTypeScreen();
        break;
      case '/client-details':
        page = const ClientDetailsScreen();
        break;
      case '/schedule':
        page = const ScheduleContactScreen();
        break;
      case '/request-confirmation':
        page = const RequestConfirmationScreen();
        break;

      // ── Admin panel ─────────────────────────────────────────────────────
      case '/admin-login':
        page = const AdminLoginScreen();
        break;
      case '/admin-dashboard':
        page = const AdminDashboardScreen();
        break;
      case '/admin-request-detail':
        page = const AdminRequestDetailScreen();
        break;

      // ── Utility ─────────────────────────────────────────────────────────
      case '/no-internet':
        page = NoInternetScreen(
          onRetry: () {
            // Handled by ConnectivityWrapper
          },
        );
        break;
      default:
        page = const SplashScreen();
    }

    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}

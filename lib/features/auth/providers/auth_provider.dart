import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/user_model.dart';
import '../services/appwrite_service.dart';
import '../services/otp_service.dart';

// ─── Service Providers ──────────────────────────────

final appwriteServiceProvider = Provider<AppwriteService>((ref) {
  return AppwriteService();
});

final otpServiceProvider = Provider<OtpService>((ref) {
  return OtpService();
});

// ─── Auth State ─────────────────────────────────────

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;
  final String? otpSessionId;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.otpSessionId,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
    String? otpSessionId,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      otpSessionId: otpSessionId ?? this.otpSessionId,
    );
  }
}

// ─── Auth Notifier ──────────────────────────────────

class AuthNotifier extends StateNotifier<AuthState> {
  final AppwriteService _appwriteService;
  final OtpService _otpService;

  AuthNotifier(this._appwriteService, this._otpService)
      : super(const AuthState());

  /// Convert raw exceptions into user-friendly messages.
  String _friendlyError(Object e) {
    if (e is TimeoutException) {
      return 'Connection timed out. Please check your internet and try again.';
    }
    if (e is AppwriteException) {
      return 'Server error. Please try again later.';
    }
    if (e is ApiException) {
      final msg = e.message.toLowerCase();
      if (msg.contains('timeout') || msg.contains('network')) {
        return 'Network error. Please check your internet connection.';
      }
      return 'Could not send OTP. Please try again.';
    }
    if (e is OtpException) return e.message;
    return 'Something went wrong. Please try again.';
  }

  /// Check if user is already logged in via SharedPreferences.
  Future<bool> checkExistingSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;

    if (isLoggedIn) {
      final name = prefs.getString(AppConstants.keyUserName) ?? '';
      final mobile = prefs.getString(AppConstants.keyLoggedInMobile) ?? '';
      state = AuthState(
        status: AuthStatus.authenticated,
        user: UserModel(
          fullName: name,
          mobileNumber: mobile,
          isVerified: true,
        ),
      );
      return true;
    }
    return false;
  }

  /// Sign up: create user in Supabase, then send OTP.
  Future<void> signUp(String fullName, String mobile) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      // Check if user already exists
      final exists = await _appwriteService.checkUserExists(mobile);
      if (exists) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'This mobile number is already registered. Please login.',
        );
        return;
      }

      // Create user
      final user = await _appwriteService.createUser(fullName, mobile);

      // Send OTP
      final sessionId = await _otpService.sendOtp(mobile);

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: user,
        otpSessionId: sessionId,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _friendlyError(e),
      );
    }
  }

  /// Login: check user exists in Supabase, then send OTP.
  Future<void> login(String mobile) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _appwriteService.getUserByMobile(mobile);
      if (user == null) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'This mobile number is not registered. Please sign up.',
        );
        return;
      }

      // Send OTP
      final sessionId = await _otpService.sendOtp(mobile);

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: user,
        otpSessionId: sessionId,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _friendlyError(e),
      );
    }
  }

  /// Verify OTP and update user verification status.
  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final sessionId = state.otpSessionId;
      if (sessionId == null) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'OTP session expired. Please try again.',
        );
        return false;
      }

      final isVerified = await _otpService.verifyOtp(sessionId, otp);
      if (!isVerified) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid OTP. Please try again.',
        );
        return false;
      }

      // Update verification status in Appwrite
      final mobile = state.user?.mobileNumber ?? '';
      await _appwriteService.updateVerificationStatus(mobile);

      // Save session locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsLoggedIn, true);
      await prefs.setString(
        AppConstants.keyLoggedInMobile,
        mobile,
      );
      await prefs.setString(
        AppConstants.keyUserName,
        state.user?.fullName ?? '',
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: state.user?.copyWith(isVerified: true),
      );
      return true;
    } on OtpExpiredException {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'OTP has expired. Please request a new one.',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  /// Resend OTP (returns new session ID).
  Future<bool> resendOtp() async {
    try {
      final mobile = state.user?.mobileNumber ?? '';
      if (mobile.isEmpty) return false;

      final sessionId = await _otpService.sendOtp(mobile);
      state = state.copyWith(otpSessionId: sessionId, errorMessage: null);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  /// Logout: clear saved session.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyIsLoggedIn);
    await prefs.remove(AppConstants.keyLoggedInMobile);
    await prefs.remove(AppConstants.keyUserName);

    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// ─── Provider ───────────────────────────────────────

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final appwriteService = ref.read(appwriteServiceProvider);
  final otpService = ref.read(otpServiceProvider);
  return AuthNotifier(appwriteService, otpService);
});

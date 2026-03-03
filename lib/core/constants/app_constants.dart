/// Application-wide constants.
class AppConstants {
  AppConstants._();

  // ─── Supabase ────────────────────────────────────
  /// Replace with your Supabase project URL.
  static const String supabaseUrl = 'https://pmdicznuxlghjeviyalib.supabase.co';

  /// Replace with your Supabase anon/public key.
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtZGljem51eGxnaGpldnlpYWxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3NDg4MjEsImV4cCI6MjA4NDMyNDgyMX0.xgMiVczzMwtQQOdwTO0y6K87aV5b_34270YrKakqD48';

  // ─── 2Factor.in ──────────────────────────────────
  /// Replace with your 2Factor.in API key.
  static const String twoFactorApiKey = 'bf27c2bb-04a9-11f1-a6b2-0200cd936042';

  static const String twoFactorBaseUrl = 'https://2factor.in/API/V1';

  // ─── WebView ─────────────────────────────────────
  static const String homeWebUrl = 'https://shamadhan.in/';

  // ─── OTP ─────────────────────────────────────────
  static const int otpExpirySeconds = 120; // 2 minutes
  static const int otpMaxRetries = 3;
  static const int otpLength = 6;

  // ─── SharedPreferences Keys ──────────────────────
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyLoggedInMobile = 'logged_in_mobile';
  static const String keyUserName = 'user_name';
  static const String keyIsLoggedIn = 'is_logged_in';

  // ─── Database ────────────────────────────────────
  static const String usersTable = 'users';
}

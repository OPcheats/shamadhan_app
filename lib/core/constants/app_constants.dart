/// Application-wide constants.
class AppConstants {
  AppConstants._();

  // ─── Appwrite ─────────────────────────────────────
  static const String appwriteEndpoint = 'https://sgp.cloud.appwrite.io/v1';
  static const String appwriteProjectId = '69a70f620029fee9a7a2';
  static const String appwriteDatabaseId = 'shamadhan_db';      // ← set your DB ID here
  static const String appwriteUsersCollectionId = 'users';      // ← set your Collection ID here

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

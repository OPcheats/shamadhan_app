/// User-facing strings centralised for easy editing / localisation.
class AppStrings {
  AppStrings._();

  // ─── App ─────────────────────────────────────────
  static const String appName = 'Shamadhan';
  static const String appTagline = 'Reliable Home Services';

  // ─── Onboarding ──────────────────────────────────
  static const String onboarding1Title = 'Trusted Home\nServices';
  static const String onboarding1Desc =
      'Book verified professionals for plumbing, electrical, carpentry, and more with guaranteed quality.';

  static const String onboarding2Title = 'Fast & Secure\nBooking';
  static const String onboarding2Desc =
      'Book services in seconds with our secure platform. Your data and payments are always protected.';

  static const String onboarding3Title = 'Track & Manage\nEasily';
  static const String onboarding3Desc =
      'Track your bookings in real time, manage your schedule, and stay updated every step of the way.';

  static const String skip = 'Skip';
  static const String next = 'Next';
  static const String getStarted = 'Get Started';

  // ─── Auth ────────────────────────────────────────
  static const String login = 'Login';
  static const String signUp = 'Sign Up';
  static const String fullName = 'Full Name';
  static const String mobileNumber = 'Mobile Number';
  static const String loginSubtitle = 'Enter your mobile number to continue';
  static const String signUpSubtitle = 'Create your account to get started';
  static const String noAccount = "Don't have an account? ";
  static const String haveAccount = 'Already have an account? ';
  static const String alreadyRegistered = 'This mobile number is already registered. Please login.';
  static const String invalidNumber = 'This mobile number is not registered. Please sign up.';
  static const String enterValidMobile = 'Please enter a valid 10-digit mobile number';
  static const String enterFullName = 'Please enter your full name';

  // ─── OTP ─────────────────────────────────────────
  static const String verifyOtp = 'Verify OTP';
  static const String otpSent = 'We have sent a verification code to';
  static const String resendOtp = 'Resend OTP';
  static const String otpExpired = 'OTP has expired. Please request a new one.';
  static const String maxRetriesReached = 'Maximum retries reached. Please try again later.';
  static const String verifying = 'Verifying...';

  // ─── Home ────────────────────────────────────────
  static const String home = 'Home';
  static const String profile = 'Profile';
  static const String logout = 'Logout';
  static const String logoutConfirm = 'Are you sure you want to logout?';
  static const String cancel = 'Cancel';
  static const String yes = 'Yes';

  // ─── Internet ────────────────────────────────────
  static const String noInternet = 'No Internet Connection';
  static const String noInternetDesc =
      'Please check your internet connection and try again.';
  static const String retry = 'Retry';

  // ─── Errors ──────────────────────────────────────
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
  static const String networkError = 'Network error. Please check your connection.';
  static const String pageLoadError = 'Failed to load the page. Please try again.';
}

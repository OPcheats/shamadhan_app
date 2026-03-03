/// Input validation utilities.
class Validators {
  Validators._();

  /// Validate Indian mobile number (10 digits, starts with 6-9).
  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final cleaned = value.trim().replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 10) {
      return 'Enter a valid 10-digit mobile number';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
      return 'Enter a valid Indian mobile number';
    }
    return null;
  }

  /// Validate full name (minimum 2 characters).
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  /// Validate OTP (6 digits).
  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }
    if (value.trim().length != 6 || !RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit OTP';
    }
    return null;
  }

  /// Clean mobile number (remove non-digit characters).
  static String cleanMobile(String mobile) {
    return mobile.replaceAll(RegExp(r'[^0-9]'), '');
  }
}

import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';

/// Service for sending and verifying OTP via 2Factor.in API.
class OtpService {
  final ApiClient _apiClient;

  OtpService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  /// Send OTP to the given mobile number.
  /// Returns the session ID on success, throws on failure.
  Future<String> sendOtp(String mobile) async {
    final url =
        '${AppConstants.twoFactorBaseUrl}/${AppConstants.twoFactorApiKey}/SMS/$mobile/AUTOGEN/OTP1';

    final response = await _apiClient.get(url);

    if (response['Status'] == 'Success') {
      return response['Details'] as String; // session ID
    } else {
      throw OtpException(
        response['Details'] as String? ?? 'Failed to send OTP',
      );
    }
  }

  /// Verify OTP using session ID and user-entered OTP.
  /// Returns true if verified, false otherwise.
  Future<bool> verifyOtp(String sessionId, String otp) async {
    final url =
        '${AppConstants.twoFactorBaseUrl}/${AppConstants.twoFactorApiKey}/SMS/VERIFY/$sessionId/$otp';

    final response = await _apiClient.get(url);

    if (response['Status'] == 'Success') {
      return response['Details'] == 'OTP Matched';
    } else {
      final details = response['Details'] as String? ?? '';
      if (details.contains('Expired') || details.contains('expired')) {
        throw OtpExpiredException('OTP has expired');
      }
      return false;
    }
  }

  void dispose() {
    _apiClient.dispose();
  }
}

/// Base OTP exception.
class OtpException implements Exception {
  final String message;
  OtpException(this.message);

  @override
  String toString() => 'OtpException: $message';
}

/// Thrown when OTP has expired.
class OtpExpiredException extends OtpException {
  OtpExpiredException(super.message);
}

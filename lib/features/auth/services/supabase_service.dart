import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Service layer for Supabase database operations on the `users` table.
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService() : _client = Supabase.instance.client;

  /// Check if a user with the given mobile number already exists.
  Future<bool> checkUserExists(String mobileNumber) async {
    final response = await _client
        .from(AppConstants.usersTable)
        .select('id')
        .eq('mobile_number', mobileNumber)
        .maybeSingle();

    return response != null;
  }

  /// Create a new user with is_verified = false.
  Future<UserModel> createUser(String fullName, String mobileNumber) async {
    final data = {
      'full_name': fullName,
      'mobile_number': mobileNumber,
      'is_verified': false,
    };

    final response = await _client
        .from(AppConstants.usersTable)
        .insert(data)
        .select()
        .single();

    return UserModel.fromJson(response);
  }

  /// Retrieve user by mobile number.
  Future<UserModel?> getUserByMobile(String mobileNumber) async {
    final response = await _client
        .from(AppConstants.usersTable)
        .select()
        .eq('mobile_number', mobileNumber)
        .maybeSingle();

    if (response == null) return null;
    return UserModel.fromJson(response);
  }

  /// Update is_verified = true after OTP verification.
  Future<void> updateVerificationStatus(String mobileNumber) async {
    await _client
        .from(AppConstants.usersTable)
        .update({'is_verified': true})
        .eq('mobile_number', mobileNumber);
  }
}

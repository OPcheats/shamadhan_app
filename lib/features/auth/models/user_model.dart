/// Data model representing a user in the Supabase `users` table.
class UserModel {
  final String? id;
  final String fullName;
  final String mobileNumber;
  final bool isVerified;
  final DateTime? createdAt;

  const UserModel({
    this.id,
    required this.fullName,
    required this.mobileNumber,
    this.isVerified = false,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      fullName: json['full_name'] as String? ?? '',
      mobileNumber: json['mobile_number'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'mobile_number': mobileNumber,
      'is_verified': isVerified,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? mobileNumber,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

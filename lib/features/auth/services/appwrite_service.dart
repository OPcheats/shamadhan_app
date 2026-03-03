import 'package:appwrite/appwrite.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Service layer for Appwrite database operations on the `users` collection.
class AppwriteService {
  late final Client _client;
  late final Databases _db;

  AppwriteService() {
    _client = Client()
      ..setEndpoint(AppConstants.appwriteEndpoint)
      ..setProject(AppConstants.appwriteProjectId);

    _db = Databases(_client);
  }

  /// Check if a user with the given mobile number already exists.
  Future<bool> checkUserExists(String mobileNumber) async {
    final result = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteUsersCollectionId,
      queries: [Query.equal('mobile_number', mobileNumber)],
    );
    return result.total > 0;
  }

  /// Create a new user with is_verified = false.
  Future<UserModel> createUser(String fullName, String mobileNumber) async {
    final doc = await _db.createDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteUsersCollectionId,
      documentId: ID.unique(),
      data: {
        'full_name': fullName,
        'mobile_number': mobileNumber,
        'is_verified': false,
      },
    );
    return UserModel.fromJson(doc.data);
  }

  /// Retrieve user by mobile number.
  Future<UserModel?> getUserByMobile(String mobileNumber) async {
    final result = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteUsersCollectionId,
      queries: [Query.equal('mobile_number', mobileNumber)],
    );
    if (result.total == 0) return null;
    return UserModel.fromJson(result.documents.first.data);
  }

  /// Update is_verified = true after OTP verification.
  Future<void> updateVerificationStatus(String mobileNumber) async {
    final result = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteUsersCollectionId,
      queries: [Query.equal('mobile_number', mobileNumber)],
    );
    if (result.total == 0) return;

    final docId = result.documents.first.$id;
    await _db.updateDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteUsersCollectionId,
      documentId: docId,
      data: {'is_verified': true},
    );
  }
}

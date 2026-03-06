import 'package:appwrite/appwrite.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

const _kTimeout = Duration(seconds: 10);

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
    ).timeout(_kTimeout);
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
    ).timeout(_kTimeout);
    return UserModel.fromJson(doc.data);
  }

  /// Retrieve user by mobile number.
  Future<UserModel?> getUserByMobile(String mobileNumber) async {
    final result = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteUsersCollectionId,
      queries: [Query.equal('mobile_number', mobileNumber)],
    ).timeout(_kTimeout);
    if (result.total == 0) return null;
    return UserModel.fromJson(result.documents.first.data);
  }

  /// Update is_verified = true after OTP verification.
  Future<void> updateVerificationStatus(String mobileNumber) async {
    final result = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteUsersCollectionId,
      queries: [Query.equal('mobile_number', mobileNumber)],
    ).timeout(_kTimeout);
    if (result.total == 0) return;

    final docId = result.documents.first.$id;
    await _db.updateDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteUsersCollectionId,
      documentId: docId,
      data: {'is_verified': true},
    ).timeout(_kTimeout);
  }
  /// Save a service request to the `service_requests` collection.
  Future<void> saveServiceRequest(Map<String, dynamic> data) async {
    await _db.createDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteServiceRequestsCollectionId,
      documentId: ID.unique(),
      data: data,
    ).timeout(_kTimeout);
  }

  /// Fetch all service requests — used by the admin dashboard.
  Future<List<Map<String, dynamic>>> listServiceRequests() async {
    final result = await _db.listDocuments(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteServiceRequestsCollectionId,
      queries: [Query.orderDesc('\$createdAt'), Query.limit(100)],
    ).timeout(const Duration(seconds: 15));

    return result.documents.map((doc) {
      final map = Map<String, dynamic>.from(doc.data);
      map['\$id'] = doc.$id;
      map['\$createdAt'] = doc.$createdAt;
      return map;
    }).toList();
  }
}


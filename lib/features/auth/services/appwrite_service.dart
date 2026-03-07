import 'package:appwrite/appwrite.dart';
import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

const _kTimeout = Duration(seconds: 10);

/// Service layer for Appwrite database operations on the `users` collection.
class AppwriteService {
  late final Client _client;
  late final Databases _db;
  late final Account _account;

  AppwriteService() {
    _client = Client()
      ..setEndpoint(AppConstants.appwriteEndpoint)
      ..setProject(AppConstants.appwriteProjectId);

    _db = Databases(_client);
    _account = Account(_client);
    
    // Ensure we have at least an anonymous session for permissions to work
    ensureSession();
  }

  /// Ensures the user has a valid Appwrite session (anonymous if not logged in).
  Future<void> ensureSession() async {
    try {
      await _account.get();
    } catch (_) {
      try {
        await _account.createAnonymousSession();
      } catch (e) {
        print('Error creating session: $e');
      }
    }
  }

  /// Log in as the admin user in Appwrite.
  Future<void> loginAdmin() async {
    try {
      // Clear any existing session (Anonymous or otherwise) to ensure clean admin login
      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (_) { /* No session to delete */ }

      // Log in with Admin credentials
      await _account.createEmailPasswordSession(
        email: 'piyushpaul108@gmail.com', 
        password: 'shamadhan@2024',
      );
    } catch (e) {
      print('Admin Appwrite login failed: $e');
      rethrow;
    }
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
  /// Save a service request to the `service_requests` collection with specific permissions.
  Future<void> saveServiceRequest(Map<String, dynamic> data) async {
    try {
      // Ensure we have a session before trying to get account info
      await ensureSession();
      
      // Get the currently logged-in user's ID from Appwrite account
      final user = await _account.get();
      final clientUserId = user.$id;
      final adminUserId = AppConstants.appwriteAdminUserId;

      await _db.createDocument(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.appwriteServiceRequestsCollectionId,
        documentId: ID.unique(),
        data: {
          ...data,
          'status': 'pending', // Default status
        },
        permissions: [
          Permission.read(Role.user(clientUserId)),
          // Note: Admin access is managed via Collection-level permissions in Appwrite Console
        ],
      ).timeout(_kTimeout);
    } catch (e) {
      // Fallback or rethrow if permissions cannot be set (e.g., no active session)
      rethrow;
    }
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

  /// Update the status of a service request document.
  Future<void> updateServiceRequestStatus(String docId, String status) async {
    await _db.updateDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteServiceRequestsCollectionId,
      documentId: docId,
      data: {'status': status},
    ).timeout(_kTimeout);
  }

  /// Delete a service request document.
  Future<void> deleteServiceRequest(String docId) async {
    await _db.deleteDocument(
      databaseId: AppConstants.appwriteDatabaseId,
      collectionId: AppConstants.appwriteServiceRequestsCollectionId,
      documentId: docId,
    ).timeout(_kTimeout);
  }
}


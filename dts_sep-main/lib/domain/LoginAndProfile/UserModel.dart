// lib/domain/LoginAndProfile/UserModel.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role; // admin / preacher / officer
  final String status; // Active / Inactive etc
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return UserModel(
      userId: doc.id,
      fullName: (d['fullName'] ?? '').toString(),
      email: (d['email'] ?? '').toString(),
      phoneNumber: (d['phoneNumber'] ?? '').toString(),
      role: (d['role'] ?? '').toString(),
      status: (d['status'] ?? '').toString(),
      createdAt: d['createdAt'] as Timestamp?,
      updatedAt: d['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'role': role,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class PreacherProfile {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const PreacherProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory PreacherProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return PreacherProfile(
      userId: doc.id,
      fullName: (d['fullName'] ?? '').toString(),
      email: (d['email'] ?? '').toString(),
      phoneNumber: (d['phoneNumber'] ?? '').toString(),
      address: (d['address'] ?? '').toString(),
      createdAt: d['createdAt'] as Timestamp?,
      updatedAt: d['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class OfficerProfile {
  final String userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const OfficerProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.createdAt,
    this.updatedAt,
  });

  factory OfficerProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return OfficerProfile(
      userId: doc.id,
      fullName: (d['fullName'] ?? '').toString(),
      email: (d['email'] ?? '').toString(),
      phoneNumber: (d['phoneNumber'] ?? '').toString(),
      address: (d['address'] ?? '').toString(),
      createdAt: d['createdAt'] as Timestamp?,
      updatedAt: d['updatedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class RegistrationRequest {
  final String requestId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String password; // (your current system uses plain password)
  final String roleRequested; // preacher / officer
  final String status; // Pending / Approved / Rejected
  final Timestamp? submittedAt;

  const RegistrationRequest({
    required this.requestId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.password,
    required this.roleRequested,
    required this.status,
    this.submittedAt,
  });

  factory RegistrationRequest.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data() ?? {};
    return RegistrationRequest(
      requestId: doc.id,
      fullName: (d['fullName'] ?? '').toString(),
      email: (d['email'] ?? '').toString(),
      phoneNumber: (d['phoneNumber'] ?? '').toString(),
      address: (d['address'] ?? '').toString(),
      password: (d['password'] ?? '').toString(),
      roleRequested: (d['roleRequested'] ?? '').toString(),
      status: (d['status'] ?? '').toString(),
      submittedAt: d['submittedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'address': address,
    'password': password,
    'roleRequested': roleRequested,
    'status': status,
    'submittedAt': submittedAt,
  };
}

class LoginRecord {
  final String email;
  final String password; // you can replace with hash later
  final String role;

  const LoginRecord({
    required this.email,
    required this.password,
    required this.role,
  });
}

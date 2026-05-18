import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a user in the `users` Firestore collection.
/// Both doctors and patients use this model; patient-specific fields are nullable.
///
/// NOTE: The old `levels: Map<String, LevelProgress>` field has been removed.
/// Patient level data is now stored as a subcollection:
/// `users/{patientUid}/levels/{levelId}` — see LevelModel.
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // "doctor" | "patient"
  final DateTime createdAt;

  // Patient-only fields (null for doctors)
  final String? dateOfBirth;   // dd/mm/aaaa
  final int? age;
  final String? dateOfSurgery; // dd/mm/aaaa
  final String? doctorUid;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    this.dateOfBirth,
    this.age,
    this.dateOfSurgery,
    this.doctorUid,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      uid: data['uid'] as String? ?? doc.id,
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      role: data['role'] as String? ?? 'patient',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      dateOfBirth: data['dateOfBirth'] as String?,
      age: data['age'] as int?,
      dateOfSurgery: data['dateOfSurgery'] as String?,
      doctorUid: data['doctorUid'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    final map = <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };

    if (role == 'patient') {
      map['dateOfBirth'] = dateOfBirth;
      map['age'] = age;
      map['dateOfSurgery'] = dateOfSurgery;
      map['doctorUid'] = doctorUid;
    }

    return map;
  }
}

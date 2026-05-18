import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/level_model.dart';
import '../models/survey_model.dart';
import '../models/user_model.dart';

/// Firestore database service.
///
/// Collections:
///   - `users`                       — doctors and patients
///   - `users/{uid}/levels`          — per-patient rehabilitation levels (subcollection)
///   - `surveys`                     — end-of-level pain surveys submitted by patients
///
/// NOTE: The global `levels` collection has been removed. Each patient now has
/// their own level subcollection, enabling unique exercise assignments per patient.
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Collection references ────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  CollectionReference<Map<String, dynamic>> get _surveys =>
      _db.collection('surveys');

  /// Returns the levels subcollection reference for a specific patient.
  CollectionReference<Map<String, dynamic>> _patientLevels(String patientUid) =>
      _users.doc(patientUid).collection('levels');

  // ══════════════════════════════════════════════════════════════════════════════
  // USERS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Writes a new [UserModel] document to `users/{uid}`.
  Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toFirestore());
  }

  /// Returns a real-time stream of a single user document.
  Stream<UserModel> getUserStream(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) throw Exception('User $uid not found in Firestore.');
      return UserModel.fromFirestore(doc);
    });
  }

  /// Returns a one-time fetch of a user document (used in auth gate).
  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  /// Returns a real-time stream of all patient documents.
  Stream<List<UserModel>> getPatientsStream() {
    return _users
        .where('role', isEqualTo: 'patient')
        .snapshots()
        .map((snap) => snap.docs.map(UserModel.fromFirestore).toList());
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // PER-PATIENT LEVELS (subcollection)
  // ══════════════════════════════════════════════════════════════════════════════

  /// Creates a level document in the patient's levels subcollection.
  /// Returns the new document ID.
  Future<String> createPatientLevel(
      String patientUid, LevelModel level) async {
    final ref = _patientLevels(patientUid).doc(); // auto-generated ID
    final levelWithId = level.copyWith(id: ref.id);
    await ref.set(levelWithId.toFirestore());
    return ref.id;
  }

  /// Updates an existing level document (exercises, YouTube URLs, etc.).
  Future<void> updatePatientLevel(
      String patientUid, LevelModel level) async {
    await _patientLevels(patientUid).doc(level.id).update({
      'exercises': level.exercises.map((e) => e.toMap()).toList(),
    });
  }

  /// Deletes a level and reorders remaining levels sequentially.
  Future<void> deletePatientLevel(
      String patientUid, String levelId) async {
    await _patientLevels(patientUid).doc(levelId).delete();
    await _reorderPatientLevels(patientUid);
  }

  /// Fetches all patient levels ordered by `order` and re-assigns
  /// sequential order values (1, 2, 3, …) via a batch write.
  Future<void> _reorderPatientLevels(String patientUid) async {
    final snap =
        await _patientLevels(patientUid).orderBy('order').get();
    final batch = _db.batch();
    for (int i = 0; i < snap.docs.length; i++) {
      batch.update(snap.docs[i].reference, {
        'order': i + 1,
        'title': 'Nível ${i + 1}',
      });
    }
    await batch.commit();
  }

  /// Returns a real-time stream of all levels for a specific patient, sorted by order.
  Stream<List<LevelModel>> getPatientLevelsStream(String patientUid) {
    return _patientLevels(patientUid)
        .orderBy('order')
        .snapshots()
        .map((snap) => snap.docs.map(LevelModel.fromFirestore).toList());
  }

  /// Updates the status of a patient's level identified by [levelOrder].
  ///
  /// Queries the subcollection for the doc with matching `order` field,
  /// then updates `status` (and optionally `completedAt`).
  Future<void> updatePatientLevelStatus(
    String patientUid,
    int levelOrder,
    String newStatus, {
    bool markCompleted = false,
  }) async {
    final snap = await _patientLevels(patientUid)
        .where('order', isEqualTo: levelOrder)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return;

    final update = <String, dynamic>{'status': newStatus};
    if (markCompleted) {
      update['completedAt'] = Timestamp.now();
    }
    await snap.docs.first.reference.update(update);
  }

  // ══════════════════════════════════════════════════════════════════════════════
  // SURVEYS
  // ══════════════════════════════════════════════════════════════════════════════

  /// Writes a survey to the `surveys` collection with an auto-generated ID.
  Future<void> submitSurvey(SurveyModel survey) async {
    final ref = _surveys.doc(); // auto-generated ID
    await ref.set(survey.toFirestore());
  }

  /// Returns a real-time stream of all surveys for a given patient.
  Stream<List<SurveyModel>> getSurveysForPatient(String patientUid) {
    return _surveys
        .where('patientUid', isEqualTo: patientUid)
        .orderBy('levelOrder')
        .snapshots()
        .map((snap) => snap.docs.map(SurveyModel.fromFirestore).toList());
  }

  /// Returns surveys for a specific patient AND level order.
  Stream<List<SurveyModel>> getSurveysForPatientLevel(
      String patientUid, int levelOrder) {
    return _surveys
        .where('patientUid', isEqualTo: patientUid)
        .where('levelOrder', isEqualTo: levelOrder)
        .snapshots()
        .map((snap) => snap.docs.map(SurveyModel.fromFirestore).toList());
  }
}

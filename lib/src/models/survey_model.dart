import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a patient's pain survey submitted at the end of a level.
/// Stored in the `surveys` Firestore collection.
class SurveyModel {
  final String id;          // Firestore document ID
  final String patientUid;
  final int levelOrder;     // Which level this survey corresponds to
  final int painBefore;     // 1-5 scale: pain before exercises
  final int painDuring;     // 1-5 scale: pain during exercises
  final int painAfter;      // 1-5 scale: pain after exercises
  final DateTime submittedAt;

  const SurveyModel({
    required this.id,
    required this.patientUid,
    required this.levelOrder,
    required this.painBefore,
    required this.painDuring,
    required this.painAfter,
    required this.submittedAt,
  });

  factory SurveyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SurveyModel(
      id: doc.id,
      patientUid: data['patientUid'] as String? ?? '',
      levelOrder: data['levelOrder'] as int? ?? 0,
      painBefore: data['painBefore'] as int? ?? 0,
      painDuring: data['painDuring'] as int? ?? 0,
      painAfter: data['painAfter'] as int? ?? 0,
      submittedAt: data['submittedAt'] != null
          ? (data['submittedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'patientUid': patientUid,
      'levelOrder': levelOrder,
      'painBefore': painBefore,
      'painDuring': painDuring,
      'painAfter': painAfter,
      'submittedAt': Timestamp.fromDate(submittedAt),
    };
  }
}

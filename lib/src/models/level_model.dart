import 'package:cloud_firestore/cloud_firestore.dart';

/// A single exercise item within a level, holding display title and YouTube URL.
class ExerciseItem {
  final String title;
  final String videoUrl; // YouTube URL, e.g. https://www.youtube.com/watch?v=...

  const ExerciseItem({
    required this.title,
    required this.videoUrl,
  });

  factory ExerciseItem.fromMap(Map<String, dynamic> map) {
    return ExerciseItem(
      title: map['title'] as String? ?? '',
      videoUrl: map['videoUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'videoUrl': videoUrl,
    };
  }
}

/// Represents a rehabilitation level stored in the per-patient subcollection
/// `users/{patientUid}/levels/{levelId}`.
///
/// Each patient has their own independent set of levels assigned by the doctor.
/// Status and completion tracking are merged directly into this model
/// (replacing the old LevelProgress cross-reference via UserModel.levels).
class LevelModel {
  final String id;           // Firestore document ID
  final int order;           // 1-based sequential display order
  final String title;        // "Nível 1", "Nível 2", etc.
  final List<ExerciseItem> exercises;
  final String status;       // "available" | "completed" | "waiting" | "locked"
  final DateTime? completedAt; // non-null when status == "completed"
  final DateTime createdAt;
  final String createdBy;    // UID of the doctor who created the level

  const LevelModel({
    required this.id,
    required this.order,
    required this.title,
    required this.exercises,
    this.status = 'locked',
    this.completedAt,
    required this.createdAt,
    required this.createdBy,
  });

  factory LevelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final rawExercises = data['exercises'] as List<dynamic>? ?? [];
    final exercises = rawExercises
        .map((e) => ExerciseItem.fromMap(e as Map<String, dynamic>))
        .toList();

    return LevelModel(
      id: doc.id,
      order: data['order'] as int? ?? 0,
      title: data['title'] as String? ?? '',
      exercises: exercises,
      status: data['status'] as String? ?? 'locked',
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      createdBy: data['createdBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'order': order,
      'title': title,
      'exercises': exercises.map((e) => e.toMap()).toList(),
      'status': status,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  LevelModel copyWith({
    String? id,
    int? order,
    String? title,
    List<ExerciseItem>? exercises,
    String? status,
    DateTime? completedAt,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return LevelModel(
      id: id ?? this.id,
      order: order ?? this.order,
      title: title ?? this.title,
      exercises: exercises ?? this.exercises,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

class ExerciseModel {
  final int id;
  final String title;
  final String videoPath;
  final int phase;
  final String duration;
  final int? nextExerciseId;
  final int? previousExerciseId;

  const ExerciseModel({
    required this.id,
    required this.title,
    required this.videoPath,
    required this.phase,
    this.duration = '2 min',
    this.nextExerciseId,
    this.previousExerciseId,
  });

  // Simple mocked global list for the views to lookup nextExerciseId
  static final List<ExerciseModel> mockExercises = [
    // Fase 1
    const ExerciseModel(id: 1,  title: '1. Pendular',                      videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase1/1.1PENDULAR.mp4',                          phase: 1, nextExerciseId: 2,    previousExerciseId: null),
    const ExerciseModel(id: 2,  title: '2. Mobilização do Cotovelo',        videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase1/1.2MOBILIZACAODOCOTOVELO.mp4',            phase: 1, nextExerciseId: 3,    previousExerciseId: 1),
    const ExerciseModel(id: 3,  title: '3. Mobilidade Escapular',           videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase1/1.3MOBILIDADEESCAPULAR.mp4',               phase: 1, nextExerciseId: null, previousExerciseId: 2),
    // Fase 2
    const ExerciseModel(id: 4,  title: '1. Flexão de Ombro',              videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase2/2.1FLEXAODEOMBRO.mp4',                   phase: 2, nextExerciseId: 5,    previousExerciseId: null),
    const ExerciseModel(id: 5,  title: '2. Rotação Lateral com Bastão',   videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase2/2.2ROTACAOLATERALBASTAO.mp4',             phase: 2, nextExerciseId: 6,    previousExerciseId: 4),
    const ExerciseModel(id: 6,  title: '3. Abdução com Bastão',           videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase2/2.3ABDUCAOCOMBASTAO.mp4',                phase: 2, nextExerciseId: null, previousExerciseId: 5),
    // Fase 3
    const ExerciseModel(id: 7,  title: '1. Flexão de Ombro Isometria',    videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase3/3.1FLEXAODEOMBROISOMETRIA.mp4',          phase: 3, nextExerciseId: 8,    previousExerciseId: null),
    const ExerciseModel(id: 8,  title: '2. Flexão Deitado com Bastão',    videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase3/3.2FLEXAODEITADOCOMBASTAO.mp4',          phase: 3, nextExerciseId: 9,    previousExerciseId: 7),
    const ExerciseModel(id: 9,  title: '3. Flexão no Plano Escapular',    videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase3/3.3FLEXAONOPLANOESCAPULAR.mp4',          phase: 3, nextExerciseId: 10,   previousExerciseId: 8),
    const ExerciseModel(id: 10, title: '4. Rotação Interna com Bastão',   videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase3/3.4ROTACAOINTERNACOMBASTAO.mp4',         phase: 3, nextExerciseId: 11,   previousExerciseId: 9),
    const ExerciseModel(id: 11, title: '5. Rotação Lateral Isometria',    videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase3/3.5ROTACAOLATERALISOMETRIA.mp4',          phase: 3, nextExerciseId: null, previousExerciseId: 10),
  ];

  static ExerciseModel? getById(int id) {
    try {
      return mockExercises.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/list_tiles/list_containers.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../models/level_model.dart';

/// Arguments bundled for ExerciseView navigation.
class ExerciseViewArgs {
  final ExerciseItem exercise;
  final int currentIndex;          // 0-based index of the current exercise
  final int totalExercises;        // total count in the level
  final int levelOrder;            // level.order (used for survey + completion)
  final String levelTitle;         // for display in ExerciseView appBar
  final List<ExerciseItem> allExercises; // full list to enable next navigation

  const ExerciseViewArgs({
    required this.exercise,
    required this.currentIndex,
    required this.totalExercises,
    required this.levelOrder,
    required this.levelTitle,
    required this.allExercises,
  });
}

/// Exercise list screen for a given level.
///
/// Receives a [LevelModel] as a named-route argument.
/// Renders each [ExerciseItem] as a tappable tile navigating to [ExerciseView].
class PhaseDetailView extends StatelessWidget {
  final LevelModel level;

  const PhaseDetailView({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final exercises = level.exercises;

    return Scaffold(
      backgroundColor: MY_WHITE,
      appBar: AppBar(
        title: Text(level.title, style: APP_BAR()),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Escolha o exercício',
                style: H2(textColor: MY_BLACK),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${exercises.length} exercício${exercises.length != 1 ? 's' : ''} neste nível',
                style: BODY(textColor: MY_DARK_GREY),
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: exercises.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum exercício disponível neste nível.',
                          style: BODY(textColor: MY_DARK_GREY),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemCount: exercises.length,
                        separatorBuilder: (ctx, i) =>
                            const SizedBox(height: 16.0),
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return SimpleListContainerTile(
                            title: exercise.title,
                            topInfo: [
                              level.title,
                              '${index + 1} de ${exercises.length}',
                            ],
                            imagePath: 'assets/dummy.png',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/exercise',
                                arguments: ExerciseViewArgs(
                                  exercise: exercise,
                                  currentIndex: index,
                                  totalExercises: exercises.length,
                                  levelOrder: level.order,
                                  levelTitle: level.title,
                                  allExercises: exercises,
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

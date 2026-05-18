import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../models/level_model.dart';
import 'phase_detail_view.dart' show ExerciseViewArgs;

/// Displays a single exercise with an embedded YouTube player.
///
/// Accepts [ExerciseViewArgs] as a named-route argument.
///
/// Navigation logic:
///   - Non-last exercise → "Próximo exercício" replaces with next ExerciseView
///   - Last exercise → "Concluir" navigates to /survey
///
/// [ExerciseItem.videoUrl] must be a valid YouTube URL (any format:
/// youtube.com/watch?v=... or youtu.be/... etc.).
class ExerciseView extends StatefulWidget {
  final ExerciseViewArgs args;
  const ExerciseView({super.key, required this.args});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  late YoutubePlayerController _ytController;

  ExerciseViewArgs get _args => widget.args;
  ExerciseItem get _exercise => _args.exercise;
  bool get _isLastExercise => _args.currentIndex == _args.totalExercises - 1;

  @override
  void initState() {
    super.initState();
    final videoId =
        YoutubePlayer.convertUrlToId(_exercise.videoUrl) ?? '';
    _ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: false,
        enableCaption: false,
      ),
    );
  }

  @override
  void dispose() {
    _ytController.dispose();
    super.dispose();
  }

  Future<void> _confirmExit(BuildContext context) async {
    // Pause video during dialog
    _ytController.pause();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Interromper exercícios?'),
        content: const Text('Deseja sair e voltar à lista de níveis?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('SIM',
                style: TextStyle(
                    color: MY_DARK_GREY, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MY_BLUE,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('NÃO',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Pop back to PatientHomeView (which is the AuthGate root)
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else if (confirmed == false) {
      _ytController.play();
    }
  }

  void _handleNext(BuildContext context) {
    if (_isLastExercise) {
      Navigator.pushReplacementNamed(
        context,
        '/survey',
        arguments: {
          'levelOrder': _args.levelOrder,
          'levelTitle': _args.levelTitle,
          'patientUid': FirebaseAuth.instance.currentUser?.uid ?? '',
        },
      );
    } else {
      final nextExercise = _args.allExercises[_args.currentIndex + 1];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ExerciseView(
            args: ExerciseViewArgs(
              exercise: nextExercise,
              currentIndex: _args.currentIndex + 1,
              totalExercises: _args.totalExercises,
              levelOrder: _args.levelOrder,
              levelTitle: _args.levelTitle,
              allExercises: _args.allExercises,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressLabel =
        '${_args.currentIndex + 1} / ${_args.totalExercises}';

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _ytController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: MY_BLUE,
        progressColors: ProgressBarColors(
          playedColor: MY_BLUE,
          handleColor: MY_BLUE,
        ),
      ),
      builder: (context, player) => Scaffold(
        backgroundColor: MY_WHITE,
        appBar: AppBar(
          title: Text(
            _exercise.title.toUpperCase(),
            style: APP_BAR(),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _confirmExit(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(progressLabel,
                    style: DETAILS(textColor: Colors.white70)),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Exercise title (above video) ─────────────────────────
                Text(
                  _exercise.title,
                  style: H1(textColor: MY_BLACK),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24.0),

                // ── YouTube Player (centered) ────────────────────────────
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: player,
                  ),
                ),

                const Spacer(),

                // ── Navigation Buttons ────────────────────────────────────
                Row(
                  children: [
                    // Back button — only when not the first exercise
                    if (_args.currentIndex > 0) ...[
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: MY_BLUE),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Exercício anterior',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: MY_BLUE),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                    ],

                    // Next / Conclude button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MY_BLUE,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        onPressed: () => _handleNext(context),
                        child: Text(
                          _isLastExercise
                              ? 'Concluir ${_args.levelTitle}'
                              : 'Próximo exercício',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';
import 'package:reabilita_ombro/src/models/exercise_model.dart';

class ExerciseView extends StatefulWidget {
  final ExerciseModel exercise;

  const ExerciseView({super.key, required this.exercise});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseVideo();
  }

  Future<void> _initializeFirebaseVideo() async {
    try {
      // 1. Resolve Firebase gs:// URL to HTTP download URL
      final storageRef = FirebaseStorage.instance.refFromURL(widget.exercise.videoPath);
      final downloadUrl = await storageRef.getDownloadURL();

      // 2. Load the network URL
      final controller = VideoPlayerController.networkUrl(Uri.parse(downloadUrl));
      await controller.initialize();

      if (mounted) {
        // 3. Attach a listener so play/pause icon re-renders automatically
        controller.addListener(() {
          if (mounted) setState(() {});
        });

        setState(() {
          _controller = controller;
        });
        _controller!.play();
        _controller!.setLooping(true);
      }
    } catch (error) {
      debugPrint('Error loading video from Firebase: $error');
    }
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _confirmExit(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Interromper exercícios?'),
        content: const Text(
          'Interromper exercícios e voltar para o início?',
        ),
        actions: [
          // "SIM" — destructive, rendered as subdued TextButton
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'SIM',
              style: TextStyle(color: MY_DARK_GREY, fontWeight: FontWeight.w500),
            ),
          ),
          // "NÃO" — safe action, rendered as filled primary button to draw attention
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MY_BLUE,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'NÃO',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MY_WHITE,
      appBar: AppBar(
        title: Text(widget.exercise.title.toUpperCase(), style: APP_BAR()),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => _confirmExit(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8.0),
                    // Expanded fills remaining vertical space, preventing overflow.
                    // AspectRatio(9/16) enforces fixed portrait dimensions.
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Semantics(
                            button: true,
                            label: 'Tocar ou pausar vídeo',
                            child: GestureDetector(
                              onTap: _togglePlayPause,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: ColoredBox(
                                  color: MY_GREY,
                                  child: (_controller != null && _controller!.value.isInitialized)
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            FittedBox(
                                              fit: BoxFit.cover,
                                              child: SizedBox(
                                                width: _controller!.value.size.width,
                                                height: _controller!.value.size.height,
                                                child: VideoPlayer(_controller!),
                                              ),
                                            ),
                                            // Play icon overlay — only visible when paused
                                            if (!_controller!.value.isPlaying)
                                              const IgnorePointer(
                                                child: Icon(
                                                  Icons.play_circle_fill,
                                                  size: 64,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                          ],
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  // "Previous" button: only shown when there is a previous exercise.
                  if (widget.exercise.previousExerciseId != null) ...[  
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: MY_BLUE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          final prevExercise = ExerciseModel.getById(widget.exercise.previousExerciseId!);
                          if (prevExercise != null) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/exercise',
                              arguments: prevExercise,
                            );
                          }
                        },
                        child: Text(
                          'Exercício anterior',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: MY_BLUE,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                  ],
                  // "Next" / "Conclude" button — stretches full-width when no previous.
                  Expanded(
                    flex: widget.exercise.previousExerciseId != null ? 1 : 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MY_BLUE,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (widget.exercise.nextExerciseId != null) {
                          final nextExercise = ExerciseModel.getById(widget.exercise.nextExerciseId!);
                          if (nextExercise != null) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/exercise',
                              arguments: nextExercise,
                            );
                            return;
                          }
                        }
                        Navigator.pushReplacementNamed(
                          context,
                          '/completion',
                          arguments: widget.exercise.phase,
                        );
                      },
                      child: Text(
                        widget.exercise.nextExerciseId != null
                            ? 'Próximo exercício'
                            : 'Concluir Fase ${widget.exercise.phase}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



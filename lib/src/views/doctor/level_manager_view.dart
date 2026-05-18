import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/text_fields/text_fields.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../../models/level_model.dart';
import '../../services/database_service.dart';

// ── Argument class ─────────────────────────────────────────────────────────────
class LevelManagerArgs {
  final String patientUid;          // patient this level belongs to
  final LevelModel? existingLevel; // null = create mode
  final int nextOrder;             // used in create mode for auto-naming

  const LevelManagerArgs({
    required this.patientUid,
    this.existingLevel,
    required this.nextOrder,
  });

  bool get isEditMode => existingLevel != null;
}

// ── Exercise form entry ────────────────────────────────────────────────────────
class _ExerciseEntry {
  final TextEditingController titleController;
  final TextEditingController videoUrlController;

  _ExerciseEntry({String? initialTitle, String? initialUrl})
      : titleController = TextEditingController(text: initialTitle ?? ''),
        videoUrlController = TextEditingController(text: initialUrl ?? '');

  void dispose() {
    titleController.dispose();
    videoUrlController.dispose();
  }
}

/// Doctor-facing level editor.
/// Create mode → accepts a new level order, creates a Firestore doc.
/// Edit mode   → accepts an existing LevelModel, updates its exercises.
///
/// Each exercise row has:
///   - A title text field
///   - A YouTube URL text field with live thumbnail preview
///
/// On save, validates all URLs via YoutubePlayer.convertUrlToId().
class LevelManagerView extends StatefulWidget {
  final LevelManagerArgs args;
  const LevelManagerView({super.key, required this.args});

  @override
  State<LevelManagerView> createState() => _LevelManagerViewState();
}

class _LevelManagerViewState extends State<LevelManagerView> {
  final _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  final List<_ExerciseEntry> _exercises = [];
  bool _isSaving = false;

  LevelManagerArgs get _args => widget.args;
  String get _levelTitle => _args.isEditMode
      ? _args.existingLevel!.title
      : 'Nível ${_args.nextOrder}';

  @override
  void initState() {
    super.initState();
    if (_args.isEditMode) {
      for (final ex in _args.existingLevel!.exercises) {
        _exercises.add(_ExerciseEntry(
          initialTitle: ex.title,
          initialUrl: ex.videoUrl,
        ));
      }
    }
    if (_exercises.isEmpty) _exercises.add(_ExerciseEntry());
  }

  @override
  void dispose() {
    for (final e in _exercises) {
      e.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate all YouTube URLs
    for (int i = 0; i < _exercises.length; i++) {
      final url = _exercises[i].videoUrlController.text.trim();
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Exercício ${i + 1}: URL do YouTube inválida.',
              style: BODY(textColor: MY_WHITE),
            ),
            backgroundColor: MY_DARK_GREY,
          ),
        );
        return;
      }
    }

    setState(() => _isSaving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final exerciseList = _exercises
          .map((e) => ExerciseItem(
                title: e.titleController.text.trim(),
                videoUrl: e.videoUrlController.text.trim(),
              ))
          .toList();

      if (_args.isEditMode) {
        await _db.updatePatientLevel(
          _args.patientUid,
          _args.existingLevel!.copyWith(exercises: exerciseList),
        );
      } else {
        // First level for this patient is immediately available;
        // subsequent levels start as locked.
        final isFirst = _args.nextOrder == 1;
        final level = LevelModel(
          id: '',
          order: _args.nextOrder,
          title: _levelTitle,
          exercises: exerciseList,
          status: isFirst ? 'available' : 'locked',
          createdAt: DateTime.now(),
          createdBy: uid,
        );
        await _db.createPatientLevel(_args.patientUid, level);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar: $e',
                style: BODY(textColor: MY_WHITE)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MY_WHITE,
      appBar: AppBar(
        backgroundColor: MY_BLUE,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _args.isEditMode ? 'Editar $_levelTitle' : 'Novo $_levelTitle',
          style: APP_BAR(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 16.0),
              color: MY_BLUE.withValues(alpha: 0.06),
              child: Text(_levelTitle, style: H1(textColor: MY_BLACK)),
            ),

            // Exercise list — rebuilds on URL changes for live thumbnail
            Expanded(
              child: StatefulBuilder(
                builder: (context, setListState) => ListView.separated(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: _exercises.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) => _ExerciseRow(
                    index: index,
                    entry: _exercises[index],
                    onUrlChanged: () => setListState(() {}),
                    onRemove: _exercises.length > 1
                        ? () => setState(() {
                              _exercises[index].dispose();
                              _exercises.removeAt(index);
                            })
                        : null,
                  ),
                ),
              ),
            ),

            // Add exercise button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _exercises.add(_ExerciseEntry())),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: MY_BLUE),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 0),
                ),
                icon: Icon(Icons.add, color: MY_BLUE),
                label: Text('Adicionar exercício',
                    style: BODY(textColor: MY_BLUE)),
              ),
            ),
            const SizedBox(height: 16.0),

            // Save button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : SimpleButton(
                      dark: false,
                      title: 'Salvar nível',
                      onTap: _save,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Single exercise row ────────────────────────────────────────────────────────
class _ExerciseRow extends StatelessWidget {
  final int index;
  final _ExerciseEntry entry;
  final VoidCallback? onRemove;
  final VoidCallback onUrlChanged;

  const _ExerciseRow({
    required this.index,
    required this.entry,
    required this.onRemove,
    required this.onUrlChanged,
  });

  @override
  Widget build(BuildContext context) {
    final videoId =
        YoutubePlayer.convertUrlToId(entry.videoUrlController.text.trim());
    final hasThumbnail = videoId != null && videoId.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: MY_WHITE,
        border: Border.all(color: MY_GREY),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row number + delete
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                    color: MY_BLUE,
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                  child: Text('${index + 1}',
                      style: DETAILS(textColor: MY_WHITE)),
                ),
              ),
              const Spacer(),
              if (onRemove != null)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: MY_DARK_GREY),
                  tooltip: 'Remover exercício',
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Title field
          SimpleTextField(
            dark: false,
            label: 'NOME DO EXERCÍCIO',
            hintText: 'Ex: Rotação externa',
            controller: entry.titleController,
            errorMessage: 'Nome obrigatório',
          ),
          const SizedBox(height: 12.0),

          // YouTube URL field
          SimpleTextField(
            dark: false,
            label: 'URL DO YOUTUBE',
            hintText: 'https://www.youtube.com/watch?v=...',
            controller: entry.videoUrlController,
            errorMessage: 'URL obrigatória',
            onChanged: (val) { onUrlChanged(); return val; },
          ),

          // Live thumbnail preview
          if (hasThumbnail) ...[
            const SizedBox(height: 12.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
                height: 90,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (ctx2, err, stack) => const SizedBox.shrink(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      color: const Color(0xFF2E7D32), size: 14),
                  const SizedBox(width: 4),
                  Text('URL válida · ID: $videoId',
                      style: DETAILS(textColor: const Color(0xFF2E7D32))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

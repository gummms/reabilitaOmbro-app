import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../models/survey_model.dart';
import '../services/database_service.dart';

/// End-of-level pain survey shown after the patient completes the last exercise.
///
/// Route: `/survey`
/// Arguments: `Map<String, dynamic>` with keys:
///   - `patientUid`  : String
///   - `levelOrder`  : int
///   - `levelTitle`  : String
///
/// Flow:
///   1. Patient rates pain on 3 questions (1–5 scale).
///   2. Taps "Enviar" → writes survey + marks level completed.
///   3. If a next level exists → transitions it to "waiting".
///   4. Navigates to `/completion`.
class SurveyView extends StatefulWidget {
  final String patientUid;
  final int levelOrder;
  final String levelTitle;

  const SurveyView({
    super.key,
    required this.patientUid,
    required this.levelOrder,
    required this.levelTitle,
  });

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  final _db = DatabaseService();

  int? _painBefore;
  int? _painDuring;
  int? _painAfter;
  bool _isSubmitting = false;

  bool get _canSubmit =>
      _painBefore != null && _painDuring != null && _painAfter != null;

  Future<void> _submit() async {
    if (!_canSubmit || _isSubmitting) return;
    setState(() => _isSubmitting = true);

    try {
      // 1. Write survey document
      final survey = SurveyModel(
        id: '',
        patientUid: widget.patientUid,
        levelOrder: widget.levelOrder,
        painBefore: _painBefore!,
        painDuring: _painDuring!,
        painAfter: _painAfter!,
        submittedAt: DateTime.now(),
      );
      await _db.submitSurvey(survey);

      // 2. Mark current level as completed
      await _db.updatePatientLevelStatus(
        widget.patientUid,
        widget.levelOrder,
        'completed',
        markCompleted: true,
      );

      // 3. Transition next level to "waiting" if it exists
      final nextOrder = widget.levelOrder + 1;
      final levels = await _db.getPatientLevelsStream(widget.patientUid).first;
      final nextExists = levels.any((l) => l.order == nextOrder);
      bool showWaiting = false;
      if (nextExists) {
        await _db.updatePatientLevelStatus(
          widget.patientUid,
          nextOrder,
          'waiting',
        );
        showWaiting = true;
      }

      // 4. Navigate to CompletionView (replace so back doesn't return here)
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/completion',
          arguments: {
            'levelTitle': widget.levelTitle,
            'showWaiting': showWaiting,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar pesquisa: $e',
                style: BODY(textColor: MY_WHITE)),
            backgroundColor: MY_RED,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
        automaticallyImplyLeading: false,
        title: Text('Como você se sentiu?', style: APP_BAR()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ────────────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: MY_BLUE.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: MY_BLUE.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: MY_BLUE, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.levelTitle,
                              style: H2(textColor: MY_BLUE)),
                          const SizedBox(height: 2),
                          Text('Exercícios concluídos!',
                              style: DETAILS(textColor: MY_BLUE)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Avalie seu nível de dor em cada momento:',
                style: BODY(textColor: MY_DARK_GREY),
              ),
              const SizedBox(height: 24),

              // ── Questions ────────────────────────────────────────────────────
              _PainQuestion(
                question: 'Nível de dor ANTES dos exercícios',
                value: _painBefore,
                onChanged: (v) => setState(() => _painBefore = v),
              ),
              const SizedBox(height: 20),

              _PainQuestion(
                question: 'Nível de dor DURANTE os exercícios',
                value: _painDuring,
                onChanged: (v) => setState(() => _painDuring = v),
              ),
              const SizedBox(height: 20),

              _PainQuestion(
                question: 'Nível de dor DEPOIS dos exercícios',
                value: _painAfter,
                onChanged: (v) => setState(() => _painAfter = v),
              ),
              const SizedBox(height: 36),

              // ── Scale legend ─────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1 = Nenhuma',
                      style: DETAILS(textColor: MY_DARK_GREY)),
                  Text('5 = Muito forte',
                      style: DETAILS(textColor: MY_DARK_GREY)),
                ],
              ),
              const SizedBox(height: 36),

              // ── Submit button ─────────────────────────────────────────────────
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedOpacity(
                      opacity: _canSubmit ? 1.0 : 0.4,
                      duration: const Duration(milliseconds: 200),
                      child: SimpleButton(
                        dark: false,
                        title: 'Enviar',
                        onTap: _canSubmit ? _submit : () {},
                      ),
                    ),

              if (!_canSubmit) ...[
                const SizedBox(height: 12),
                Text(
                  'Responda todas as perguntas para continuar.',
                  style: DETAILS(textColor: MY_DARK_GREY),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pain scale question widget ─────────────────────────────────────────────────
class _PainQuestion extends StatelessWidget {
  final String question;
  final int? value;
  final ValueChanged<int> onChanged;

  const _PainQuestion({
    required this.question,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(question, style: BODY(textColor: MY_BLACK)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final score = i + 1;
              final isSelected = value == score;
              return GestureDetector(
                onTap: () => onChanged(score),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? _colorForScore(score) : MY_WHITE,
                    border: Border.all(
                      color: isSelected
                          ? _colorForScore(score)
                          : MY_GREY,
                      width: isSelected ? 2 : 1,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: _colorForScore(score)
                                  .withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : MY_DARK_GREY,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Returns a color on a green → yellow → red spectrum based on pain score.
  Color _colorForScore(int score) {
    return switch (score) {
      1 => const Color(0xFF2E7D32), // deep green — no pain
      2 => const Color(0xFF7CB342), // light green — mild
      3 => const Color(0xFFF9A825), // amber — moderate
      4 => const Color(0xFFEF6C00), // orange — significant
      _ => const Color(0xFFC62828), // deep red — severe
    };
  }
}

import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../../models/survey_model.dart';
import '../../services/database_service.dart';
import 'patient_detail_view.dart' show SurveyResultsArgs;

/// Doctor's view of a patient's survey answers for a specific level.
///
/// Receives [SurveyResultsArgs] as a named-route argument.
/// Streams `DatabaseService.getSurveysForPatientLevel(patientUid, levelOrder)`.
/// If no survey submitted yet, shows a placeholder.
class SurveyResultsView extends StatelessWidget {
  final SurveyResultsArgs args;
  const SurveyResultsView({super.key, required this.args});

  static final _db = DatabaseService();

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
        title: Text('Pesquisa — ${args.levelTitle}', style: APP_BAR()),
      ),
      body: SafeArea(
        child: StreamBuilder<List<SurveyModel>>(
          stream: _db.getSurveysForPatientLevel(
              args.patientUid, args.levelOrder),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Text('Erro ao carregar pesquisa.',
                    style: BODY(textColor: MY_DARK_GREY)),
              );
            }

            final surveys = snap.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient info header
                  Text(args.patientName, style: H1(textColor: MY_BLACK)),
                  const SizedBox(height: 4),
                  Text(args.levelTitle,
                      style: BODY(textColor: MY_DARK_GREY)),
                  const SizedBox(height: 24),

                  surveys.isEmpty
                      ? _EmptySurvey()
                      : Column(
                          children: surveys
                              .map((s) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: _SurveyCard(survey: s),
                                  ))
                              .toList(),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Single survey card ─────────────────────────────────────────────────────────
class _SurveyCard extends StatelessWidget {
  final SurveyModel survey;
  const _SurveyCard({required this.survey});

  @override
  Widget build(BuildContext context) {
    final d = survey.submittedAt;
    final dateStr =
        '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}'
        ' às ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: MY_WHITE,
        border: Border.all(color: MY_GREY),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_turned_in_outlined,
                  color: MY_BLUE, size: 20),
              const SizedBox(width: 8),
              Text('Respondido em $dateStr',
                  style: DETAILS(textColor: MY_DARK_GREY)),
            ],
          ),
          const SizedBox(height: 20),
          _PainRow(
            label: 'Dor ANTES dos exercícios',
            score: survey.painBefore,
          ),
          const SizedBox(height: 16),
          _PainRow(
            label: 'Dor DURANTE os exercícios',
            score: survey.painDuring,
          ),
          const SizedBox(height: 16),
          _PainRow(
            label: 'Dor DEPOIS dos exercícios',
            score: survey.painAfter,
          ),
        ],
      ),
    );
  }
}

// ── Pain score row with visual gauge ──────────────────────────────────────────
class _PainRow extends StatelessWidget {
  final String label;
  final int score; // 1-5

  const _PainRow({required this.label, required this.score});

  Color _colorFor(int s) {
    if (s <= 1) return const Color(0xFF2E7D32);
    if (s <= 2) return const Color(0xFF7CB342);
    if (s == 3) return const Color(0xFFF57C00);
    if (s == 4) return const Color(0xFFE64A19);
    return const Color(0xFFB71C1C);
  }

  String _labelFor(int s) {
    const labels = ['', 'Nenhuma', 'Leve', 'Moderada', 'Forte', 'Muito forte'];
    return s >= 1 && s <= 5 ? labels[s] : '-';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BODY(textColor: MY_BLACK)),
        const SizedBox(height: 8),
        Row(
          children: [
            // Score dots
            Row(
              children: List.generate(5, (i) {
                final filled = i < score;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: filled ? _colorFor(score) : MY_GREY,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: filled ? Colors.white : MY_DARK_GREY,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(width: 8),
            Text(
              '${_labelFor(score)} ($score/5)',
              style: DETAILS(textColor: _colorFor(score))
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────
class _EmptySurvey extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment_outlined, size: 64, color: MY_GREY),
          const SizedBox(height: 16),
          Text(
            'Pesquisa ainda não respondida.',
            style: BODY(textColor: MY_DARK_GREY),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'O paciente deve concluir o nível para responder.',
            style: DETAILS(textColor: MY_DARK_GREY),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

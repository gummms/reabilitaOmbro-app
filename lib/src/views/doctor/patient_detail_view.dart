import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../../models/level_model.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';
import 'level_manager_view.dart';

/// Route args for SurveyResultsView
class SurveyResultsArgs {
  final String patientUid;
  final int levelOrder;
  final String levelTitle;
  final String patientName;

  const SurveyResultsArgs({
    required this.patientUid,
    required this.levelOrder,
    required this.levelTitle,
    required this.patientName,
  });
}

/// Doctor's view of a single patient's assigned levels and progress.
///
/// Header: patient metadata (name, age, DOB, surgery date).
/// Body: StreamBuilder on the patient's levels subcollection.
///   - Each level card shows status, completedAt, and action buttons.
///   - "Liberar" button: releases a "waiting" level to "available".
///   - "Ver Pesquisa" button: navigates to SurveyResultsView.
///   - Edit/delete icons: manage individual levels.
/// FAB: creates a new level for this patient.
class PatientDetailView extends StatelessWidget {
  final UserModel patient;
  const PatientDetailView({super.key, required this.patient});

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
        title: Text(patient.name, style: APP_BAR()),
      ),
      body: SafeArea(
        child: StreamBuilder<List<LevelModel>>(
          stream: _db.getPatientLevelsStream(patient.uid),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Text('Erro ao carregar níveis.',
                    style: BODY(textColor: MY_DARK_GREY)),
              );
            }

            final levels = snap.data ?? [];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Patient Header Card ─────────────────────────────────────
                  _PatientHeader(patient: patient),
                  const SizedBox(height: 32.0),

                  // ── Níveis Section ──────────────────────────────────────────
                  Row(
                    children: [
                      Text('Níveis Atribuídos', style: H1(textColor: MY_BLACK)),
                      const Spacer(),
                      Text(
                        '${levels.length} nível${levels.length != 1 ? 'is' : ''}',
                        style: DETAILS(textColor: MY_DARK_GREY),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  if (levels.isEmpty)
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 24),
                          Icon(Icons.layers_outlined, size: 64, color: MY_GREY),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum nível atribuído ainda.',
                            style: BODY(textColor: MY_DARK_GREY),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Toque em + para adicionar o primeiro nível.',
                            style: DETAILS(textColor: MY_DARK_GREY),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: List.generate(levels.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _LevelProgressCard(
                            level: levels[i],
                            patient: patient,
                            db: _db,
                            allLevels: levels,
                          ),
                        );
                      }),
                    ),

                  // Bottom padding so FAB doesn't overlap last card
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: _AddLevelFab(patient: patient, db: _db),
    );
  }
}

// ── Add-level FAB ──────────────────────────────────────────────────────────────
class _AddLevelFab extends StatelessWidget {
  final UserModel patient;
  final DatabaseService db;
  const _AddLevelFab({required this.patient, required this.db});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LevelModel>>(
      stream: db.getPatientLevelsStream(patient.uid),
      builder: (context, snap) {
        final nextOrder = (snap.data?.length ?? 0) + 1;
        return FloatingActionButton.extended(
          backgroundColor: MY_BLUE,
          tooltip: 'Adicionar nível',
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('Novo nível',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
          onPressed: () => Navigator.pushNamed(
            context,
            '/level_manager',
            arguments: LevelManagerArgs(
              patientUid: patient.uid,
              nextOrder: nextOrder,
            ),
          ),
        );
      },
    );
  }
}

// ── Patient header ─────────────────────────────────────────────────────────────
class _PatientHeader extends StatelessWidget {
  final UserModel patient;
  const _PatientHeader({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [MY_BLUE, MY_BLUE.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Text(
                  _initials(patient.name),
                  style: H1(textColor: MY_WHITE),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(patient.name, style: H1(textColor: MY_WHITE)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(label: 'Idade', value: '${patient.age ?? '-'} anos'),
          const SizedBox(height: 4),
          _InfoRow(label: 'Nascimento', value: patient.dateOfBirth ?? '-'),
          const SizedBox(height: 4),
          _InfoRow(label: 'Cirurgia', value: patient.dateOfSurgery ?? '-'),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    return parts
        .map((p) => p.isNotEmpty ? p[0] : '')
        .take(2)
        .join()
        .toUpperCase();
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label: ', style: DETAILS(textColor: Colors.white70)),
        Text(value,
            style: DETAILS(textColor: MY_WHITE)
                .copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ── Level progress card ────────────────────────────────────────────────────────
class _LevelProgressCard extends StatefulWidget {
  final LevelModel level;
  final UserModel patient;
  final DatabaseService db;
  final List<LevelModel> allLevels;

  const _LevelProgressCard({
    required this.level,
    required this.patient,
    required this.db,
    required this.allLevels,
  });

  @override
  State<_LevelProgressCard> createState() => _LevelProgressCardState();
}

class _LevelProgressCardState extends State<_LevelProgressCard> {
  bool _isReleasing = false;

  Future<void> _releaseLevel() async {
    setState(() => _isReleasing = true);
    try {
      await widget.db.updatePatientLevelStatus(
        widget.patient.uid,
        widget.level.order,
        'available',
      );
    } finally {
      if (mounted) setState(() => _isReleasing = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Excluir ${widget.level.title}?'),
        content: const Text(
            'Todos os exercícios serão removidos. Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child:
                Text('Cancelar', style: TextStyle(color: MY_DARK_GREY)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MY_RED,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await widget.db
          .deletePatientLevel(widget.patient.uid, widget.level.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.level.status;
    final completedAt = widget.level.completedAt;

    final Color statusColor = switch (status) {
      'available' => MY_BLUE,
      'completed' => const Color(0xFF2E7D32),
      'waiting' => const Color(0xFFF57C00),
      _ => MY_DARK_GREY,
    };

    final String statusLabel = switch (status) {
      'available' => 'Disponível',
      'completed' => 'Concluído',
      'waiting' => 'Aguardando liberação',
      _ => 'Bloqueado',
    };

    return Container(
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
        children: [
          // ── Header row ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Order badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text('${widget.level.order}',
                        style: BODY(textColor: MY_WHITE)
                            .copyWith(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),

                // Title + status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.level.title,
                          style: H2(textColor: MY_BLACK)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(statusLabel,
                              style: DETAILS(textColor: statusColor)),
                        ],
                      ),
                      if (status == 'completed' && completedAt != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            _formatDate(completedAt),
                            style: DETAILS(textColor: MY_DARK_GREY),
                          ),
                        ),
                    ],
                  ),
                ),

                // Edit + Delete icons
                IconButton(
                  icon: Icon(Icons.edit_outlined, color: MY_BLUE, size: 20),
                  tooltip: 'Editar nível',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/level_manager',
                    arguments: LevelManagerArgs(
                      patientUid: widget.patient.uid,
                      existingLevel: widget.level,
                      nextOrder: widget.level.order,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: MY_RED, size: 20),
                  tooltip: 'Excluir nível',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _confirmDelete,
                ),
              ],
            ),
          ),

          // ── Action divider ─────────────────────────────────────────────────
          if (status == 'waiting' || status == 'completed')
            Divider(height: 1, color: MY_GREY),

          // ── Release button ─────────────────────────────────────────────────
          if (status == 'waiting')
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 12.0),
              child: _isReleasing
                  ? const Center(
                      child: SizedBox(
                          height: 32,
                          child: CircularProgressIndicator(strokeWidth: 2)))
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MY_BLUE,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: _releaseLevel,
                        icon: const Icon(Icons.lock_open,
                            color: Colors.white, size: 18),
                        label: const Text('Liberar nível',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
            ),

          // ── Survey button ──────────────────────────────────────────────────
          if (status == 'completed')
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 12.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: MY_BLUE),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/survey_results',
                    arguments: SurveyResultsArgs(
                      patientUid: widget.patient.uid,
                      levelOrder: widget.level.order,
                      levelTitle: widget.level.title,
                      patientName: widget.patient.name,
                    ),
                  ),
                  icon: Icon(Icons.bar_chart, color: MY_BLUE, size: 18),
                  label: Text('Ver Pesquisa',
                      style: TextStyle(
                          color: MY_BLUE, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime d) =>
      'Concluído em ${d.day.toString().padLeft(2, '0')}/'
      '${d.month.toString().padLeft(2, '0')}/${d.year}';
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../models/level_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

/// Patient-facing home screen.
///
/// Streams the patient's UserModel (for name display) and their personal
/// levels subcollection `users/{uid}/levels`. Each level's status and
/// completedAt are read directly from the LevelModel — no cross-referencing.
///
/// Status display logic:
///   "available"  → blue card, tappable → navigates to /phase_detail
///   "completed"  → green card with ✓, tappable (can replay)
///   "waiting"    → grey/orange card, locked: "Aguardando liberação do médico"
///   "locked"     → grey card, locked with lock icon
class PatientHomeView extends StatelessWidget {
  const PatientHomeView({super.key});

  static final _db = DatabaseService();
  static final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: MY_WHITE,
      appBar: AppBar(
        backgroundColor: MY_BLUE,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Reabilita Ombro', style: APP_BAR()),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Sair',
            onPressed: () async {
              Navigator.of(context).popUntil((route) => route.isFirst);
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<UserModel>(
          stream: _db.getUserStream(uid),
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (userSnap.hasError || !userSnap.hasData) {
              return Center(
                child: Text(
                  'Erro ao carregar dados do usuário.',
                  style: BODY(textColor: MY_DARK_GREY),
                ),
              );
            }

            final patient = userSnap.data!;

            return StreamBuilder<List<LevelModel>>(
              stream: _db.getPatientLevelsStream(uid),
              builder: (context, levelsSnap) {
                if (levelsSnap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (levelsSnap.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar níveis.',
                      style: BODY(textColor: MY_DARK_GREY),
                    ),
                  );
                }

                final levels = levelsSnap.data ?? [];

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${patient.name.isNotEmpty ? patient.name.split(' ').first : 'Paciente'}!',
                        style: H2(textColor: MY_BLACK),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        levels.isEmpty
                            ? 'Aguardando níveis do seu médico.'
                            : 'Escolha um nível para continuar.',
                        style: BODY(textColor: MY_DARK_GREY),
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: levels.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.hourglass_top_rounded,
                                        size: 64, color: MY_GREY),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nenhum nível disponível ainda.\nSeu médico irá liberar os exercícios em breve.',
                                      style: BODY(textColor: MY_DARK_GREY),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                itemCount: levels.length,
                                separatorBuilder: (ctx, i) =>
                                    const SizedBox(height: 16.0),
                                itemBuilder: (ctx, index) {
                                  final level = levels[index];
                                  // Status and completedAt come directly from
                                  // the per-patient LevelModel — no cross-ref.
                                  return _LevelCard(
                                    level: level,
                                    status: level.status,
                                    completedAt: level.completedAt,
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/phase_detail',
                                      arguments: level,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// A single level card with status-aware visual treatment.
class _LevelCard extends StatelessWidget {
  final LevelModel level;
  final String status; // "available" | "completed" | "waiting" | "locked"
  final DateTime? completedAt;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.status,
    this.completedAt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isInteractive = status == 'available' || status == 'completed';

    final Color cardColor = switch (status) {
      'available' => MY_BLUE,
      'completed' => const Color(0xFF2E7D32),
      'waiting' => MY_DARK_GREY,
      _ => MY_GREY,
    };

    return GestureDetector(
      onTap: isInteractive ? onTap : null,
      child: AnimatedOpacity(
        opacity: isInteractive ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: isInteractive
                ? [
                    BoxShadow(
                      color: cardColor.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // Level number watermark
              Positioned(
                right: -16,
                bottom: -20,
                child: Text(
                  level.order.toString(),
                  style: TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.08),
                    height: 1,
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                  children: [
                    _StatusIcon(status: status),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(level.title,
                              style: H2(textColor: Colors.white)),
                          const SizedBox(height: 4),
                          Text(
                            _subtitleFor(status, completedAt),
                            style: DETAILS(textColor: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    if (isInteractive)
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white54, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitleFor(String status, DateTime? completedAt) {
    switch (status) {
      case 'available':
        return '${level.exercises.length} exercício${level.exercises.length != 1 ? 's' : ''}';
      case 'completed':
        if (completedAt != null) {
          final d = completedAt;
          return 'Concluído em ${d.day.toString().padLeft(2, '0')}/'
              '${d.month.toString().padLeft(2, '0')}/${d.year}';
        }
        return 'Concluído';
      case 'waiting':
        return 'Aguardando liberação do médico';
      default:
        return 'Bloqueado';
    }
  }
}

class _StatusIcon extends StatelessWidget {
  final String status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    final IconData icon = switch (status) {
      'available' => Icons.play_circle_fill,
      'completed' => Icons.check_circle,
      'waiting' => Icons.hourglass_top_rounded,
      _ => Icons.lock,
    };
    return Icon(icon, color: Colors.white, size: 36);
  }
}

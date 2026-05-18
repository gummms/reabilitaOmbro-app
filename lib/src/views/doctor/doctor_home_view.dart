import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';

/// Doctor home — single view showing the list of all registered patients.
///
/// Tapping a patient card navigates to PatientDetailView where the doctor
/// can manage that patient's individual levels and view their progress.
class DoctorHomeView extends StatelessWidget {
  const DoctorHomeView({super.key});

  static final _auth = AuthService();
  static final _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MY_WHITE,
      appBar: AppBar(
        backgroundColor: MY_BLUE,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Painel Médico', style: APP_BAR()),
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
      body: StreamBuilder<List<UserModel>>(
        stream: _db.getPatientsStream(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Text('Erro ao carregar pacientes.',
                  style: BODY(textColor: MY_DARK_GREY)),
            );
          }

          final patients = snap.data ?? [];

          if (patients.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people_outline, size: 64, color: MY_GREY),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum paciente cadastrado ainda.',
                    style: BODY(textColor: MY_DARK_GREY),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Os pacientes aparecem aqui após se cadastrarem no app.',
                    style: DETAILS(textColor: MY_DARK_GREY),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: patients.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _PatientCard(patient: patients[index]),
          );
        },
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final UserModel patient;
  const _PatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    final initials = patient.name.trim().isNotEmpty
        ? patient.name.trim().split(' ').map((p) => p[0]).take(2).join()
        : '?';

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/patient_detail',
        arguments: patient,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: MY_WHITE,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MY_GREY),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: MY_BLUE,
              child: Text(
                initials.toUpperCase(),
                style: BODY(textColor: MY_WHITE)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(patient.name, style: H2(textColor: MY_BLACK)),
                  const SizedBox(height: 2),
                  Text(
                    '${patient.age ?? '-'} anos  ·  Cirurgia: ${patient.dateOfSurgery ?? '-'}',
                    style: DETAILS(textColor: MY_DARK_GREY),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: MY_DARK_GREY),
          ],
        ),
      ),
    );
  }
}

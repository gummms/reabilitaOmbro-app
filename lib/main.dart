import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import 'firebase_options.dart';
import 'src/models/level_model.dart';
import 'src/models/user_model.dart';
import 'src/views/auth_gate.dart';
import 'src/views/login_view.dart';
import 'src/views/patient_register_view.dart';
import 'src/views/phase_detail_view.dart';
import 'src/views/exercise_view.dart';
import 'src/views/completion_view.dart';
import 'src/views/doctor/level_manager_view.dart';
import 'src/views/doctor/patient_detail_view.dart';
import 'src/views/doctor/survey_results_view.dart';

import 'src/views/survey_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reabilita Ombro',

      // ── Localizations (required for DatePickerTextField locale: pt) ────────
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ── Theme ──────────────────────────────────────────────────────────────
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MY_BLUE),
        scaffoldBackgroundColor: MY_WHITE,
        appBarTheme: AppBarTheme(
          backgroundColor: MY_BLUE,
          elevation: 0.0,
          centerTitle: true,
        ),
      ),

      // ── Root: AuthGate resolves role and pushes the correct home ──────────
      home: const AuthGate(),

      // ── Named routes (no typed arguments) ──────────────────────────────────
      routes: {
        '/login': (_) => const LoginView(),
        '/patient_register': (_) => const PatientRegisterView(),
        // /patient_home and /doctor_home are handled declaratively by AuthGate.
        // Do NOT add them as named routes — they would bypass the auth gate.
      },

      // ── Dynamic routes (typed argument passing) ───────────────────────────
      onGenerateRoute: (settings) {
        switch (settings.name) {

          // ── /phase_detail — expects LevelModel ────────────────────────────
          case '/phase_detail':
            final level = settings.arguments as LevelModel;
            return MaterialPageRoute(
              builder: (_) => PhaseDetailView(level: level),
            );

          // ── /exercise — expects ExerciseViewArgs ──────────────────────────
          case '/exercise':
            final args = settings.arguments as ExerciseViewArgs;
            return MaterialPageRoute(
              builder: (_) => ExerciseView(args: args),
            );

          // ── /completion — expects Map with levelTitle ─────────────────────
          case '/completion':
            final argsMap = settings.arguments as Map<String, dynamic>? ?? {};
            final levelTitle = argsMap['levelTitle'] as String? ?? 'Nível';
            final showWaiting = argsMap['showWaiting'] as bool? ?? false;
            return MaterialPageRoute(
              builder: (_) => CompletionView(
                levelTitle: levelTitle,
                showWaiting: showWaiting,
              ),
            );

          // ── /level_manager — expects LevelManagerArgs ─────────────────────
          case '/level_manager':
            final args = settings.arguments as LevelManagerArgs;
            return MaterialPageRoute(
              builder: (_) => LevelManagerView(args: args),
            );

          // ── /patient_detail — expects UserModel ───────────────────────────
          case '/patient_detail':
            final patient = settings.arguments as UserModel;
            return MaterialPageRoute(
              builder: (_) => PatientDetailView(patient: patient),
            );

          // ── /survey_results — expects SurveyResultsArgs ───────────────────
          case '/survey_results':
            final args = settings.arguments as SurveyResultsArgs;
            return MaterialPageRoute(
              builder: (_) => SurveyResultsView(args: args),
            );

          // ── /survey — expects Map with patientUid, levelOrder, levelTitle ──
          case '/survey':
            final surveyArgs = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => SurveyView(
                patientUid: surveyArgs['patientUid'] as String,
                levelOrder: surveyArgs['levelOrder'] as int,
                levelTitle: surveyArgs['levelTitle'] as String,
              ),
            );

          default:
            return null;
        }
      },

      debugShowCheckedModeBanner: false,
    );
  }
}

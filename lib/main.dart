import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';
// import 'package:reabilita_ombro/src/views/login_view.dart'; // MVP: login disabled, re-enable when auth is implemented
import 'package:reabilita_ombro/src/views/home_view.dart';
// Note: PhaseDetailView, ExerciseView, CompletionView should also be importable.
import 'package:reabilita_ombro/src/views/phase_detail_view.dart';
import 'package:reabilita_ombro/src/views/exercise_view.dart';
import 'package:reabilita_ombro/src/views/completion_view.dart';
import 'package:reabilita_ombro/src/models/exercise_model.dart';
import 'firebase_options.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MY_BLUE),
        scaffoldBackgroundColor: MY_WHITE,
        appBarTheme: AppBarTheme(
          backgroundColor: MY_BLUE,
          elevation: 0.0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/home', // MVP: skipping login — re-enable '/login' when auth is implemented
      routes: {
        // '/login': (context) => const LoginView(), // MVP: disabled
        '/home': (context) => const HomeView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/phase_detail') {
          final int phase = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => PhaseDetailView(phase: phase),
          );
        } else if (settings.name == '/exercise') {
          final ExerciseModel exercise = settings.arguments as ExerciseModel;
          return MaterialPageRoute(
            builder: (context) => ExerciseView(exercise: exercise),
          );
        } else if (settings.name == '/completion') {
          final int phase = (settings.arguments as int?) ?? 1;
          return MaterialPageRoute(
            builder: (context) => CompletionView(phase: phase),
          );
        }
        return null;
      },
    );
  }
}

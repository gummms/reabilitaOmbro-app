import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'doctor/doctor_home_view.dart';
import 'login_view.dart';
import 'patient_home_view.dart';

/// Declarative auth gate — shows the right widget tree based on auth state.
///
/// ARCHITECTURE NOTE:
///   This widget is the `home:` of MaterialApp and NEVER calls Navigator.push.
///   Instead it returns the correct widget directly so that:
///     - Logout (signOut()) causes the StreamBuilder to emit null → LoginView
///       is shown automatically, even if nested routes exist on the stack.
///     - Registration completes → auth state emits the new user → PatientHomeView
///       is returned → callers only need to pop() back to this gate.
///
/// Logout from any nested view should also call:
///     Navigator.of(context).popUntil((route) => route.isFirst);
///   before or after signOut() to clear stacked routes (e.g. PhaseDetailView).
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _auth = AuthService();
  final _db = DatabaseService();

  // Cache the last resolved user future so FutureBuilder doesn't re-fire
  // on every StreamBuilder rebuild.
  Future<UserModel?>? _userFuture;
  String? _cachedUid;

  Future<UserModel?> _getUserFuture(String uid) {
    if (uid != _cachedUid) {
      _cachedUid = uid;
      _userFuture = _db.getUser(uid);
    }
    return _userFuture!;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges,
      builder: (context, snapshot) {
        // ── Waiting for initial auth state ──────────────────────────────────
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingScaffold();
        }

        // ── Not authenticated → show LoginView ──────────────────────────────
        if (!snapshot.hasData || snapshot.data == null) {
          // Clear any cached user when logged out
          _cachedUid = null;
          _userFuture = null;
          return const LoginView();
        }

        // ── Authenticated → resolve role ────────────────────────────────────
        final uid = snapshot.data!.uid;
        return FutureBuilder<UserModel?>(
          future: _getUserFuture(uid),
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return _loadingScaffold();
            }

            // Firestore doc missing or error → sign out and show LoginView
            if (userSnap.hasError ||
                !userSnap.hasData ||
                userSnap.data == null) {
              // Schedule sign-out outside of build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _auth.signOut();
              });
              return _loadingScaffold();
            }

            final role = userSnap.data!.role;
            if (role == 'doctor') {
              return const DoctorHomeView();
            }
            return const PatientHomeView();
          },
        );
      },
    );
  }

  Widget _loadingScaffold() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}

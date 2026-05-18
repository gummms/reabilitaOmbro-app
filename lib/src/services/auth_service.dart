import 'package:firebase_auth/firebase_auth.dart';

/// Unified authentication service adapted from the componentes_padrao auth reference.
///
/// Reference files:
///   - squad/assets/componentes_padrao/auth/authentication/services/auth/auth.dart
///   - squad/assets/componentes_padrao/auth/authentication/services/auth/signIn_firebase.dart
///   - squad/assets/componentes_padrao/auth/authentication/services/auth/register_firebase.dart
///   - squad/assets/componentes_padrao/auth/authentication/services/auth/signOut_firebase.dart
///
/// Doctors do NOT register via the app — their credentials are pre-created
/// in the Firebase Auth console. This service intentionally exposes no registerDoctor() method.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Auth State ──────────────────────────────────────────────────────────────

  /// Stream of Firebase auth state changes. Emits [User] when logged in, null when logged out.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns the currently signed-in [User], or null if not authenticated.
  User? get currentUser => _auth.currentUser;

  // ── Sign In ─────────────────────────────────────────────────────────────────

  /// Signs in with email and password.
  /// Returns [UserCredential] on success, null on failure.
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result;
    } on FirebaseAuthException {
      // Propagate FirebaseAuthException so the UI can display specific messages.
      rethrow;
    } catch (_) {
      return null;
    }
  }

  // ── Register Patient ─────────────────────────────────────────────────────────

  /// Creates a new Firebase Auth account for a patient.
  /// Returns [UserCredential] on success, null on failure.
  ///
  /// NOTE: This does NOT write to Firestore. The caller is responsible for
  /// calling [DatabaseService.createUser()] with the resulting UID.
  Future<UserCredential?> registerPatient({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result;
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      return null;
    }
  }

  // ── Sign Out ─────────────────────────────────────────────────────────────────

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Silently fail on sign-out — the auth state stream will update regardless.
    }
  }

  // ── Auth Error Messages ──────────────────────────────────────────────────────

  /// Converts a [FirebaseAuthException] code to a user-friendly Portuguese message.
  static String translateError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Nenhuma conta encontrada com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'invalid-email':
        return 'Formato de e-mail inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 8 caracteres.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      case 'invalid-credential':
        return 'Credenciais inválidas. Verifique e-mail e senha.';
      default:
        return 'Erro de autenticação. Tente novamente.';
    }
  }
}

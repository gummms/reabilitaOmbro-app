import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/text_fields/text_fields.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../services/auth_service.dart';
import 'patient_register_view.dart';

/// Login screen adapted from the Blefaro LoginPage reference
/// (squad/assets/componentes_padrao/auth/authentication/Login.dart).
///
/// Accepts email + password. Routes to AuthGate on success, which
/// resolves the role and navigates to the correct home view.
/// Doctors are pre-created in Firebase console — no register flow for them.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result == null && mounted) {
        setState(() => _errorMessage = 'Não foi possível fazer login.');
      }
      // On success the AuthGate StreamBuilder fires automatically — no manual navigation needed.
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = AuthService.translateError(e));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MY_WHITE,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── App Title ──────────────────────────────────────────────
                  Text(
                    'Reabilita Ombro',
                    style: H1(textColor: MY_BLUE),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Acesse sua conta',
                    style: BODY(textColor: MY_DARK_GREY),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48.0),

                  // ── Email ──────────────────────────────────────────────────
                  SimpleTextField(
                    dark: false,
                    label: 'EMAIL',
                    hintText: 'Digite seu e-mail',
                    controller: _emailController,
                    errorMessage: 'E-mail inválido',
                    isEmail: true,
                  ),
                  const SizedBox(height: 16.0),

                  // ── Password ───────────────────────────────────────────────
                  ObscureTextField(
                    dark: false,
                    label: 'SENHA',
                    hintText: 'Digite sua senha',
                    controller: _passwordController,
                    errorMessage: 'Senha inválida',
                    isPassword: false, // Disable length restrictions for login
                  ),
                  const SizedBox(height: 32.0),

                  // ── Login Button ───────────────────────────────────────────
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SimpleButton(
                          dark: false,
                          title: 'ENTRAR',
                          onTap: _handleLogin,
                        ),

                  // ── Error message ──────────────────────────────────────────
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 12.0),
                    Text(
                      _errorMessage,
                      style: DETAILS(textColor: MY_RED),
                      textAlign: TextAlign.center,
                    ),
                  ],

                  const SizedBox(height: 40.0),

                  // ── Divider ────────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: MY_GREY, thickness: 1.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Não tem conta?',
                          style: DETAILS(textColor: MY_DARK_GREY),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: MY_GREY, thickness: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // ── Register Button (patients only) ────────────────────────
                  SimpleButton(
                    dark: true,
                    title: 'CADASTRAR-SE',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PatientRegisterView(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

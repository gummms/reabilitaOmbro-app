import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/text_fields/text_fields.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

/// Patient self-registration screen.
///
/// Adapted from the Blefaro register_patient.dart + Register_user.dart references
/// (squad/assets/componentes_padrao/auth/authentication/).
///
/// Collects: name, age, date of birth, date of surgery, email, password.
/// On success: creates Firebase Auth account + writes UserModel to Firestore,
/// then pops back to LoginView.
class PatientRegisterView extends StatefulWidget {
  const PatientRegisterView({super.key});

  @override
  State<PatientRegisterView> createState() => _PatientRegisterViewState();
}

class _PatientRegisterViewState extends State<PatientRegisterView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _dobController = TextEditingController();        // Date of birth
  final _surgeryDateController = TextEditingController(); // Date of surgery
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authService = AuthService();
  final _dbService = DatabaseService();

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _dobController.dispose();
    _surgeryDateController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'As senhas não coincidem.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // 1. Create Firebase Auth account
      final credential = await _authService.registerPatient(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (credential == null || credential.user == null) {
        setState(() => _errorMessage = 'Não foi possível criar a conta. Tente novamente.');
        return;
      }

      final uid = credential.user!.uid;
      final age = int.tryParse(_ageController.text.trim()) ?? 0;

      // 2. Build UserModel — no levels map; doctor assigns levels per patient.
      final user = UserModel(
        uid: uid,
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        role: 'patient',
        createdAt: DateTime.now(),
        dateOfBirth: _dobController.text,
        age: age,
        dateOfSurgery: _surgeryDateController.text,
        doctorUid: '',
      );

      // 3. Write user document to Firestore
      await _dbService.createUser(user);

      if (mounted) {
        // Pop all routes back to root — AuthGate is declarative and
        // already shows PatientHomeView since auth state has updated.
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = AuthService.translateError(e));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Erro inesperado. Tente novamente.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Date range helpers
    final now = DateTime.now();
    final oldest = DateTime(1920, 1, 1);

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
        title: Text('Criar conta', style: APP_BAR()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Insira seus dados',
                  style: H1(textColor: MY_BLACK),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Preencha todas as informações abaixo para criar sua conta.',
                  style: BODY(textColor: MY_DARK_GREY),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),

                // ── Nome ──────────────────────────────────────────────────────
                SimpleTextField(
                  dark: false,
                  label: 'NOME COMPLETO',
                  hintText: 'Digite seu nome',
                  controller: _nameController,
                  errorMessage: 'Nome obrigatório',
                ),
                const SizedBox(height: 16.0),

                // ── Idade ─────────────────────────────────────────────────────
                SimpleTextField(
                  dark: false,
                  label: 'IDADE',
                  hintText: 'Digite sua idade',
                  controller: _ageController,
                  errorMessage: 'Idade obrigatória',
                  digitsOnly: true,
                ),
                const SizedBox(height: 16.0),

                // ── Data de Nascimento ────────────────────────────────────────
                DatePickerTextField(
                  dark: false,
                  label: 'DATA DE NASCIMENTO',
                  hintText: 'dd/mm/aaaa',
                  errorMessage: 'Data de nascimento obrigatória',
                  dateController: _dobController,
                  startDate: oldest,
                  endDate: now,
                ),
                const SizedBox(height: 16.0),

                // ── Data da Cirurgia ──────────────────────────────────────────
                DatePickerTextField(
                  dark: false,
                  label: 'DATA DA CIRURGIA',
                  hintText: 'dd/mm/aaaa',
                  errorMessage: 'Data da cirurgia obrigatória',
                  dateController: _surgeryDateController,
                  startDate: oldest,
                  endDate: now,
                ),
                const SizedBox(height: 16.0),

                // ── Email ─────────────────────────────────────────────────────
                SimpleTextField(
                  dark: false,
                  label: 'EMAIL',
                  hintText: 'Digite seu e-mail',
                  controller: _emailController,
                  errorMessage: 'E-mail inválido',
                  isEmail: true,
                ),
                const SizedBox(height: 16.0),

                // ── Senha ─────────────────────────────────────────────────────
                ObscureTextField(
                  dark: false,
                  label: 'SENHA',
                  hintText: 'Mínimo 6 caracteres',
                  controller: _passwordController,
                  errorMessage: 'Senha inválida',
                  isPassword: true,
                ),
                const SizedBox(height: 16.0),

                // ── Confirmar Senha ───────────────────────────────────────────
                ObscureTextField(
                  dark: false,
                  label: 'CONFIRME SUA SENHA',
                  hintText: 'Digite sua senha novamente',
                  controller: _confirmPasswordController,
                  errorMessage: 'Confirmação obrigatória',
                  isPassword: false,
                ),
                const SizedBox(height: 32.0),

                // ── Register Button ───────────────────────────────────────────
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SimpleButton(
                        dark: false,
                        title: 'CADASTRAR',
                        onTap: _handleRegister,
                      ),

                // ── Error Message ─────────────────────────────────────────────
                if (_errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 12.0),
                  Text(
                    _errorMessage,
                    style: DETAILS(textColor: MY_RED),
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: 24.0),

                // ── Back to Login ─────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem conta? ',
                      style: BODY(textColor: MY_DARK_GREY),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        'Entrar',
                        style: BODY(textColor: MY_BLUE).copyWith(
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: MY_BLUE,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

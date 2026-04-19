import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:componentes_padrao/components/text_fields/text_fields.dart';
import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MY_WHITE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Reabilita Ombro",
                    style: H1(textColor: MY_BLUE),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48.0),
                  SimpleTextField(
                    dark: false,
                    label: "NOME",
                    hintText: "Digite seu nome",
                    controller: _nomeController,
                    errorMessage: "Nome obrigatório",
                  ),
                  const SizedBox(height: 16.0),
                  SimpleTextField(
                    dark: false,
                    label: "CPF",
                    hintText: "000.000.000-00",
                    controller: _cpfController,
                    errorMessage: "CPF inválido",
                    isCPF: true,
                  ),
                  const SizedBox(height: 32.0),
                  SimpleButton(
                    dark: false,
                    title: "ENTRAR",
                    onTap: () async {
                      try {
                        // Very basic auth logic for testing
                        // Ideally you'd use _nomeController and _cpfController here 
                        // but for demo we just sign in anonymously or mock sign in to proceed
                        await FirebaseAuth.instance.signInAnonymously();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to sign in: $e')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

class CompletionView extends StatelessWidget {
  final int phase;

  const CompletionView({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MY_WHITE,
      appBar: AppBar(
        title: Text("Reabilita Ombro", style: APP_BAR()),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: MY_BLUE,
              ),
              const SizedBox(height: 24.0),
              Text(
                "Parabéns!\nExercícios da Fase $phase de hoje concluídos!",
                style: H1(textColor: MY_BLACK),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48.0),
              SimpleButton(
                dark: false,
                title: "Voltar ao Início",
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

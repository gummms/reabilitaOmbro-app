import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

/// Shown after patient completes a level's survey.
///
/// Receives:
///   - [levelTitle]: display name of the completed level
///   - [showWaiting]: if true, shows a note that the next level awaits doctor release
class CompletionView extends StatelessWidget {
  final String levelTitle;
  final bool showWaiting;

  const CompletionView({
    super.key,
    required this.levelTitle,
    this.showWaiting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MY_WHITE,
      appBar: AppBar(
        title: Text('Reabilita Ombro', style: APP_BAR()),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.check_circle_outline, size: 80, color: MY_BLUE),
              const SizedBox(height: 24.0),
              Text(
                'Parabéns!\n$levelTitle concluído!',
                style: H1(textColor: MY_BLACK),
                textAlign: TextAlign.center,
              ),
              if (showWaiting) ...[
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: MY_BLUE.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: MY_BLUE.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.hourglass_top_rounded,
                          color: MY_BLUE, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'O próximo nível será liberado pelo seu médico.',
                          style: BODY(textColor: MY_BLUE),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 48.0),
              SimpleButton(
                dark: false,
                title: 'Voltar ao início',
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

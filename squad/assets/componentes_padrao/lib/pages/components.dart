import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:flutter/material.dart';

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Components",
          style: APP_BAR(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 42.0, horizontal: 17.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleButton(dark: false, title: "Buttons", onTap: () {}),
              SimpleButton(dark: true, title: "Text Fields", onTap: () {}),
              SimpleButton(dark: false, title: "List Tiles", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

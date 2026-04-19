import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MY_WHITE,
      appBar: AppBar(
        backgroundColor: MY_BLUE,
        elevation: 0.0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Reabilita Ombro",
          style: APP_BAR(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Olá Paciente",
                style: H2(textColor: MY_BLACK),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Escolha a Fase",
                style: BODY(textColor: MY_DARK_GREY),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    return HomeButton(
                      title: "Fase ${index + 1}",
                      imagePath: "assets/dummy.png",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/phase_detail',
                          arguments: index + 1,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

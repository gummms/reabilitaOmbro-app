import 'package:componentes_padrao/components/buttons/elevated_buttons.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/pages/set_up.dart';
import 'package:flutter/material.dart';

import 'components.dart';

class StylePage extends StatelessWidget {
  const StylePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Style Guidelines",
          style: APP_BAR(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 42.0, horizontal: 17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Style Guidelines To Follow",
              style: TITLE(),
            ),
            const SizedBox(height: 15.0),
            Text(
              "Cores",
              style: H3(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 13.0),
            Text(
              "Existem 13 cores pré-definidas para serem usadas por todo seu aplicativo, podendo ser separadas em 3 categorias diferentes: cores principais, cores secundárias ou de apoio e cores específicas.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            Text(
              "Cores Principais",
              style: H2(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 13.0),
            Text(
              "São apenas 3 cores que são usadas por todo o aplicativo: azul, branco e preto.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Text(
              "São as cores da marca LIT e não devem ser alteradas. Todo texto deve se restrigir a apenas essa categoria.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Text(
              "NÃO USE PRETO E BRANCO PUROS!",
              style: BODY().copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MY_BLUE,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "MY_BLUE",
                      style: BODY(),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFF124477",
                      style: BODY(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MY_BLACK,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "MY_BLACK",
                      style: BODY(),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFF050505",
                      style: BODY(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MY_WHITE,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: MY_BLUE, width: 1.5),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "MY_WHITE",
                      style: BODY(),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFFF9F9F9",
                      style: BODY(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35.0),
            Text(
              "Cores Secundárias ou de Apoio",
              style: H2(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 13.0),
            Text(
              "São apenas 2 cores que não tem usos definidos, mas possa ser que você precise delas para contrastar com as cores principais.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: DARK_BLUE,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "DARK_BLUE",
                      style: BODY(),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFF0E2A47",
                      style: BODY(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MY_GREY,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "MY_GREY",
                      style: BODY(),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFFD1D1D1",
                      style: BODY(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35.0),
            Text(
              "Cores Específicas",
              style: H2(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 13.0),
            Text(
              "São 8 cores que os usos são definidos, mas você pode adaptar da maneira que achar conveniente.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Text(
              "Diferentemente das outras categorias, você pode expandir a quantidade de cores conforme achar necessário durante a construção do seu aplicativo.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: TEXT_FIELD_COLOR_DARK,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "TEXT_FIELD_COLOR_DARK",
                        style: BODY(),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFF25578B",
                      style: BODY(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: TEXT_FIELD_COLOR_LIGHT,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "TEXT_FIELD_COLOR_LIGHT",
                        style: BODY(),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFFBFDEFF",
                      style: BODY(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MY_GREEN,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "MY_GREEN",
                      style: BODY(),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFF60F648",
                      style: BODY(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MY_RED,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "MY_RED",
                        style: BODY(),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFFF64848",
                      style: BODY(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: MY_YELLOW,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "MY_YELLOW",
                        style: BODY(),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFFFFE663",
                      style: BODY(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CHAT__MESSAGE_SENDER,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "CHAT__MESSAGE_SENDER",
                        style: BODY(),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFF97CAFF",
                      style: BODY(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CHAT_MESSAGE_RECEIVER,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: MY_BLUE, width: 1.5),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "CHAT_MESSAGE_RECEIVER",
                        style: BODY(),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xFFF64848",
                      style: BODY(),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CHAT_DATE_COLOR,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: 100,
                      child: Text(
                        "CHAT_DATE_COLOR",
                        style: BODY(),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "0xCC124477",
                      style: BODY(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              "Tipografia",
              style: H3(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 13.0),
            Text(
              "Os estilos de texto foram definidos com base no design padrão atual, criado com base no aplicativo da Unichristus.",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 15.0),
            Text(
              "A única fonte utilizada é a Mulish em diferentes tamanhos e pesos, disponível no pacote de fontes do Google, que você deve adicionar ao projeto. A seguir a hierarquia:",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            Text(
              "Title - Mulish - 22 - Bold",
              style: TITLE(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            Text(
              "H1 - Mulish - 20 - Bold",
              style: H1(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            Text(
              "H3 - Mulish - 18 - ExtraBold",
              style: H3(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            Text(
              "TITLE_02 - Mulish - 18 - Bold",
              style: TITLE_02(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            Text(
              "H2 - Mulish - 16 - Bold",
              style: H2(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            Text(
              "BODY - Mulish - 14 - Regular",
              style: BODY(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            Text(
              "SUBTITLE - Mulish - 12 - Medium",
              style: SUBTITLE(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20.0),
            Text(
              "DETAILS - Mulish - 10 - Medium",
              style: DETAILS(),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 42.0),
            SimpleButton(
              dark: true,
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

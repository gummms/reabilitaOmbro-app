// ignore_for_file: non_constant_identifier_names

import 'package:componentes_padrao/components/style_constants/button_styles.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A simple square button with an image background<br/>
/// This version is used to list the **different options**
/// a user can take
Widget HomeButton({
  required String title,
  required String imagePath,
  required VoidCallback onTap,
  double? width = 134,
  double? height = 134,
}) {
  return ElevatedButton(
    style: buttonStyle,
    onPressed: onTap,
    child: SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            right: -25,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                imagePath,
                width: 120,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  title,
                  style: GoogleFonts.mulish(
                    fontSize: 24, // H2 base (16) + 50% = 24
                    fontWeight: FontWeight.w700,
                    color: MY_WHITE,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// A simple button with only text. <br/>
/// <br/>
/// There is a dark and a light version to be **used accordingly**.
Widget SimpleButton({
  required bool dark,
  required String title,
  required VoidCallback onTap,
  double? width,
}) {
  return ElevatedButton(
    style: dark ? buttonStyleDark : buttonStyle,
    onPressed: onTap,
    child: SizedBox(
      width: width,
      child: Center(
        child: Text(
          title.toUpperCase(),
          style: GoogleFonts.mulish(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: dark ? MY_BLUE : MY_WHITE,
          ),
        ),
      ),
    ),
  );
}

/// Another simple button with text and a background image.<br/>
/// This version is used for **listing categories**
Widget ButtonContainer({
  required String title,
  required String imagePath,
  required VoidCallback onTap,
  double? height = 100,
  double? width,
}) {
  return ElevatedButton(
    style: buttonStyle,
    onPressed: onTap,
    child: SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            bottom: -20,
            right: -25,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                imagePath,
                width: 100,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            child: Text(
              title,
              style: H2(textColor: MY_WHITE),
            ),
          ),
        ],
      ),
    ),
  );
}

import 'package:componentes_padrao/components/style_constants/colors.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:flutter/material.dart';

/// A version of the flutter widget 'ExpansionTile', but following the LIT
/// style guidelines.<br/>
/// <br/>
/// Use this widget when you want to compile some information of your user and show only when they want to see. <br/>
/// <br/>
/// **USE ONLY ON A LIGHT BACKGROUND.**
class CustomExpasionTile extends StatefulWidget {
  const CustomExpasionTile({
    super.key,
    required this.title,
    required this.info,
  });

  final String title;
  final String info;
  @override
  State<CustomExpasionTile> createState() => _CustomExpasionTileState();
}

class _CustomExpasionTileState extends State<CustomExpasionTile> {
  bool showInfo = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RotationTransition(
          turns: showInfo
              ? const AlwaysStoppedAnimation(90 / 360)
              : const AlwaysStoppedAnimation(0),
          child: IconButton(
            onPressed: () {
              setState(() {
                showInfo = !showInfo;
              });
            },
            icon: Icon(
              Icons.arrow_right_rounded,
              size: 30,
              color: MY_BLACK,
            ),
          ),
        ),
        SizedBox(
          width: 300,
          child: Column(
            children: [
              Text(
                widget.title,
                style: H2(),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 15.0),
              Visibility(
                visible: showInfo,
                child: Text(
                  widget.info,
                  style: BODY(),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

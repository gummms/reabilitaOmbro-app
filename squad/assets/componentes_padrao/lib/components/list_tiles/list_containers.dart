// ignore_for_file: non_constant_identifier_names

import 'package:componentes_padrao/components/style_constants/colors.dart';
import 'package:componentes_padrao/components/style_constants/container_decor.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:flutter/material.dart';

/// A container to display information with a background image to indicate the
/// category of the information. To be used in list views. <br/>
/// <br/>
/// The lists _topInfo_ and _bottomInfo_ needs to be of a maximum length of 2, aka
/// it needs to have one or two items. If you **DON'T** want to show any bottom
/// info, use the widget SimpleListContainerTile. <br/>
/// <br/>
/// The _title_ is the main information you want to display. Be sure to use this
/// widget the correct way. If the tile opens a page, pass the action on the
/// _onTap_ atributte.
Widget ListContainerTile({
  required String title,
  required List<String> topInfo,
  required List<String> bottomInfo,
  required String imagePath,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: MY_WHITE,
        borderRadius: BorderRadius.circular(5),
        boxShadow: MY_BOXSHADOW,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            bottom: -32,
            right: -25,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                imagePath,
                width: 120,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                color: MY_BLUE,
                height: 119,
                width: 8,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        topInfo[0],
                        style: DETAILS(),
                      ),
                      const SizedBox(width: 5),
                      Visibility(
                        visible: topInfo.length == 2,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.all(color: MY_BLACK),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Visibility(
                        visible: topInfo.length == 2,
                        child: Text(
                          topInfo[1],
                          style: DETAILS(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    title,
                    style: H1(),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        bottomInfo[0],
                        style: BODY(),
                      ),
                      const SizedBox(width: 10),
                      Visibility(
                        visible: bottomInfo.length == 2,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.all(color: MY_BLACK),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Visibility(
                        visible: bottomInfo.length == 2,
                        child: Text(
                          bottomInfo[1],
                          style: BODY(),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// A simpler version of the widger ListContainerTile to be used to display
/// information with a background image to indicate the category of the
/// information. To be used in list views. <br/>
/// <br/>
/// The list _topInfo_ needs to be of a maximum length of 2, aka it needs to
/// have one or two items.<br/>
/// <br/>
/// The _title_ is the main information you want to display. Be sure to use this
/// widget the correct way. If the tile opens a page, pass the action on the
/// _onTap_ atributte.
Widget SimpleListContainerTile({
  required String title,
  required List<String> topInfo,
  required String imagePath,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: MY_WHITE,
        borderRadius: BorderRadius.circular(5),
        boxShadow: MY_BOXSHADOW,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            bottom: -35,
            right: -30,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                imagePath,
                width: 120,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                color: MY_BLUE,
                height: 80,
                width: 8,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        topInfo[0],
                        style: DETAILS(),
                      ),
                      const SizedBox(width: 5),
                      Visibility(
                        visible: topInfo.length == 2,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50),
                            ),
                            border: Border.all(color: MY_BLACK),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Visibility(
                        visible: topInfo.length == 2,
                        child: Text(
                          topInfo[1],
                          style: DETAILS(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  Text(
                    title,
                    style: H1(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

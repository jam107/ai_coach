import 'package:flutter/material.dart';

class MainColors {
  static Color bgColor1 = const Color(0xFF20214B);
  static Color bgColor2 = const Color(0xFF252345);
  static Color bgColor3 = const Color(0xFF353868);
  static Color primaryTextColor = const Color(0xFFFFFFFF);
  static Color secondaryTextColor = const Color(0xFF6A6B81);
  static Color accentColor = const Color(0xFFD07046);
}

class SideColors {
  static Color bgColor3_1 = const Color.fromRGBO(53, 56, 104, 0.98);
  static Color bgColor3_2 = const Color.fromRGBO(53, 56, 104, 0.97);

  static LinearGradient linearGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        MainColors.bgColor3,
        MainColors.bgColor3,
        bgColor3_1,
        bgColor3_2
      ],
      stops: const [
        0,
        0.8,
        0.9,
        1
      ]);
  static LinearGradient authGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        MainColors.bgColor3,
        MainColors.bgColor3,
        MainColors.bgColor2,
      ],
      stops: const [
        0,
        0.4,
        1
      ]);
}

import 'package:ai_coach/config/materials/colors/main_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyles {
  static final primaryHeaderStyleLogin = GoogleFonts.montserratAlternates(
    color: MainColors.primaryTextColor,
    fontSize: 48,
    fontWeight: FontWeight.w700,
  );
  static final secondaryStyleLogin1 = GoogleFonts.montserratAlternates(
    color: MainColors.primaryTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  static final primaryStyle = GoogleFonts.montserratAlternates(
      color: MainColors.primaryTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
      decorationThickness: 0,
      letterSpacing: 0.75);
  static final mainTextStyle = GoogleFonts.montserratAlternates(
    color: MainColors.primaryTextColor1,
    fontSize: 48,
    fontWeight: FontWeight.w700,
  );
  static final primaryStyle2 = GoogleFonts.montserratAlternates(
      color: MainColors.primaryTextColor1,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
      decorationThickness: 0,
      letterSpacing: 0.75);
  static final secondaryStyle = GoogleFonts.montserratAlternates(
    color: MainColors.primaryTextColor1,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static final secondaryStyleLogin2 = GoogleFonts.montserratAlternates(
    color: MainColors.primaryTextColor,
    fontSize: 16,
    fontWeight: FontWeight.w200,
  );
  static final primaryHeaderStyle = GoogleFonts.montserratAlternates(
    color: MainColors.primaryTextColor,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static final aiPageHeaderStyle = GoogleFonts.inter(
    color: MainColors.primaryTextColor1,
    fontSize: 40,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    shadows: [
      Shadow(
        offset: Offset(0, 10), // x: 0, y: 9
        blurRadius: 4, // blur: 4
        color: Colors.black.withOpacity(0.25), // %25 opaklık
      ),
    ],
  );
  static final aiPageSubHeaderStyle = GoogleFonts.inter(
    color: MainColors.primaryTextColor1,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static final aiPageSubHeaderStyle2 = GoogleFonts.inter(
    color: MainColors.primaryTextColor1,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static final aiPageSubHeaderStyle3 = GoogleFonts.inter(
    color: MainColors.primaryTextColor,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
  static final aiPageSubHeaderStyle4 = GoogleFonts.inter(
    color: MainColors.primaryTextColor,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );
}

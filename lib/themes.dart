import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  Color lightPrimaryColor = const Color(0xFFFAF5EF);
  Color lightSecondaryColor = const Color(0xFF3F0C7C);
  Color darkPrimaryColor = const Color(0xFF293652);
  Color darkSecondaryColor = const Color(0xFFFFFFFF);
  Color accentColor = const Color(0xFFF6AB1C);

  Color lightContainerCardBg = const Color(0xFFFFFFFF);
  Color darkContainerCardBg = const Color(0xFF1C2436).withOpacity(0.6);

  Color lightCardHeadBg = const Color(0xFF4831D4);
  Color darkCardHeadBg = const Color(0xFF1C2436);

  Color lightText = const Color(0xFF1C2436).withOpacity(0.8);
  Color darkText = const Color(0xFFFFFFFF).withOpacity(0.8);

  Color lightIcon = const Color(0xFF290456);
  Color darkIcon= const Color(0xFFFFFFFF).withOpacity(0.8);

  Color fadingIndicator=  Colors.grey.withOpacity(0.6);

  static ThemeData lightTheme = ThemeData(
    primaryColor: _themes.lightPrimaryColor,
    colorScheme: const ColorScheme.light().copyWith(
        primary: _themes.lightPrimaryColor,
        secondary: _themes.lightSecondaryColor,
        tertiary: _themes.lightContainerCardBg,
        surface: _themes.lightCardHeadBg),
    textTheme: GoogleFonts.actorTextTheme().copyWith(
        bodyLarge: GoogleFonts.actor(
            color: _themes.lightText,
            fontSize: 30,
            fontWeight: FontWeight.w700),
        bodyMedium: GoogleFonts.actor(
            color: _themes.lightText,
            fontSize: 15,
            fontWeight: FontWeight.w500),
        bodySmall: GoogleFonts.actor(
            color: _themes.lightText,
            fontSize: 12,)
    ),
    iconTheme: const IconThemeData().copyWith(
        color: _themes.lightIcon
    ),
    useMaterial3: true,
    dividerColor: _themes.lightIcon,
    indicatorColor: _themes.fadingIndicator,
      appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark)
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: _themes.darkPrimaryColor,
    colorScheme: const ColorScheme.dark().copyWith(
        primary: _themes.darkPrimaryColor,
        secondary: _themes.darkSecondaryColor,
        tertiary: _themes.darkContainerCardBg,
        surface: _themes.darkCardHeadBg),
    textTheme: GoogleFonts.actorTextTheme().copyWith(
        bodyLarge: GoogleFonts.actor(
            color: _themes.darkText, fontSize: 30, fontWeight: FontWeight.w700),
        bodyMedium: GoogleFonts.actor(
            color: _themes.darkText,
            fontSize: 15,
            fontWeight: FontWeight.w500),
        bodySmall: GoogleFonts.actor(
          color: _themes.darkText,
          fontSize: 12,)
    ),
    iconTheme: const IconThemeData().copyWith(
        color: _themes.darkIcon
    ),
    useMaterial3: true,
    dividerColor: _themes.accentColor,
      indicatorColor: _themes.fadingIndicator,
      appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light)
  );
}

Themes _themes = Themes();

// const Theme = {
//   light: {
//     MainBg :  "#FBFCF8",
//     ListContainerBg :"#FAF5EF",
//     ListItemBg :  "#FFFFFF",
//     ListItemIndicatorBg :  "#4831D4",
//     SelectedItemBg:  "#edeefe",
//     ItemIconBg:  "#4831D4",
//     SelectedItemIconBg:  "#F04B2E",
//     LogoLive:  "#F04B2E",
//     LogoTxt:  "#4831D4",
//     HeaderInfoLogo:"#4831D4",
//     VerticalListLine:"#4831D4",
//     GeneralTxt: "#1C2436",
//     IndicatorBg: "#293652",
//   },
//   dark: {
//     MainBg: "#293652",
//     ListContainerBg: "#1C2436" ,
//     ListItemBg: "#293652",
//     ListItemIndicatorBg: "#293652",
//     SelectedItemBg: "#334368",
//     ItemIconBg:"#FFFFFF",
//     SelectedItemIconBg:"#F6AB1C",
//     LogoLive: "#F04B2E",
//     LogoTxt: "#FFFFFF" ,
//     HeaderInfoLogo:"#FFFFFF",
//     VerticalListLine: "#293652",
//     GeneralTxt: "#F2F2F2",
//     IndicatorBg: "#FFFFFF",
//   },
// }

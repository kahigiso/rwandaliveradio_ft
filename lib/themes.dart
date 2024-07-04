import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  Color lightPrimaryColor = const Color(0xFFFFFFFF);
  Color lightSecondaryColor = const Color(0xFF4831D4);
  Color darkPrimaryColor = const Color(0xFF1C202D);
  Color darkSecondaryColor = const Color(0xFF1E1C29).withOpacity(0.8);
  Color accentColor = const Color(0xFFF6AB1C).withOpacity(0.7);

  Color lightContainerCardBg = const Color(0xFFFFFFFF);
  Color darkContainerCardBg = const Color(0xFF292F40).withOpacity(0.8);

  Color lightCardHeadBg = const Color(0xFF4831D4);
  Color darkCardHeadBg = const Color(0xFFF6AB1C).withOpacity(0.7);

  Color lightCardHeadBgCurrent = const Color(0xFFF6AB1C);
  Color darkCardHeadBgCurrent = const Color(0xFF7F8C8D).withOpacity(0.7);

  Color lightText = const Color(0xFF1C2436).withOpacity(0.8);
  Color darkText = const Color(0xFFFFFFFF).withOpacity(0.8);

  Color lightIcon = const Color(0xFF4831D4);
  Color darkIcon = const Color(0xFFF6AB1C).withOpacity(0.7);

  Color fadingIndicator = Colors.grey.withOpacity(0.6);

  static ThemeData lightTheme = ThemeData().copyWith(
    primaryColor: _themes.lightPrimaryColor,
    colorScheme: const ColorScheme.light().copyWith(
        primary: _themes.lightPrimaryColor,
        secondary: _themes.lightSecondaryColor,
        tertiary: _themes.lightContainerCardBg,
        surface: _themes.lightCardHeadBg,
        surfaceDim: _themes.lightCardHeadBgCurrent,
        onTertiary: _themes.lightCardHeadBgCurrent,
        outline:_themes.lightText
    ),
    textTheme: GoogleFonts.actorTextTheme().copyWith(
        bodyLarge: GoogleFonts.actor(
            color: _themes.lightText,
            fontSize: 30,
            fontWeight: FontWeight.w700),
        bodyMedium: GoogleFonts.actor(
            color: _themes.lightText,
            fontSize: 17,
            fontWeight: FontWeight.w500),
        bodySmall: GoogleFonts.actor(
          color: _themes.lightText,
          fontSize: 12,
        )),
    iconTheme: const IconThemeData().copyWith(color: _themes.lightIcon),
    useMaterial3: true,
    dividerColor: _themes.lightIcon,
    indicatorColor: _themes.fadingIndicator,
    appBarTheme:
    const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.dark),
    switchTheme: const SwitchThemeData().copyWith(
        thumbColor: WidgetStateProperty.all(_themes.lightPrimaryColor),
        trackColor: WidgetStateProperty.all(_themes.accentColor),
        trackOutlineColor: WidgetStateProperty.all(_themes.lightSecondaryColor),
        trackOutlineWidth:  WidgetStateProperty.all(1)

    ),
  );

  static ThemeData darkTheme = ThemeData().copyWith(
      primaryColor: _themes.darkPrimaryColor,
      colorScheme: const ColorScheme.dark().copyWith(
          primary: _themes.darkPrimaryColor,
          secondary: _themes.darkSecondaryColor,
          tertiary: _themes.darkContainerCardBg,
          surface: _themes.darkCardHeadBg,
          surfaceDim: _themes.darkCardHeadBgCurrent,
          onTertiary: _themes.darkCardHeadBgCurrent.withOpacity(0.1),
          outline:_themes.darkText
      ),
      textTheme: GoogleFonts.actorTextTheme().copyWith(
          bodyLarge: GoogleFonts.actor(
              color: _themes.darkText,
              fontSize: 30,
              fontWeight: FontWeight.w700),
          bodyMedium: GoogleFonts.actor(
              color: _themes.darkText,
              fontSize: 17,
              fontWeight: FontWeight.w500),
          bodySmall: GoogleFonts.actor(
            color: _themes.darkText,
            fontSize: 12,
          )),
      iconTheme: const IconThemeData().copyWith(color: _themes.darkIcon),
      useMaterial3: true,
      dividerColor: _themes.accentColor,
      indicatorColor: _themes.fadingIndicator,
      appBarTheme:
          const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
    switchTheme: const SwitchThemeData().copyWith(
        thumbColor: WidgetStateProperty.all(_themes.darkPrimaryColor),
        trackColor: WidgetStateProperty.all(_themes.accentColor),
        trackOutlineColor: WidgetStateProperty.all(_themes.darkSecondaryColor),
        trackOutlineWidth:  WidgetStateProperty.all(2.1)

    ),
  );
}

Themes _themes = Themes();

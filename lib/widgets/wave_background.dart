import 'package:flutter/material.dart';

import '../services/theme_handler.dart';
import 'package:get/get.dart';
import 'bottom_wave_clipper.dart';

class WaveBackground extends StatelessWidget {
  final ThemeHandler themeHandler = Get.find();
  final double height;
  WaveBackground({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    final bgColor = (!themeHandler.isDarkMode())?Theme.of(context)
        .iconTheme
        .color
        ?.withOpacity(0.5):Theme.of(context).colorScheme.tertiary;
    final opacity =(!themeHandler.isDarkMode())? 0.15: 0.4;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height,
      child: Stack(alignment: Alignment.bottomCenter, children: [
        Opacity(
            opacity:opacity,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                color: bgColor,
                height: height,
              ),
            )),
        Opacity(
            opacity: opacity,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                color: bgColor,
                height: height - height*0.08,
              ),
            )),
        Opacity(
            opacity: opacity,
            child: ClipPath(
              clipper: BottomWaveClipper(),
              child: Container(
                color: bgColor,
                height: height - height*0.16,
              ),
            )),
      ]),
    );
  }
}

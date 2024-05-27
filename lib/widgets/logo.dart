import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.15,
      child: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 125.0, top: 25),
                child: Text(
                  "Rwanda",
                  style: GoogleFonts.badScript(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 63,
                ),
                child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: Text(
                    "Live",
                    style: GoogleFonts.msMadi(
                      fontSize: 50,
                      color: const Color(0xFFF04B2E),
                      fontWeight: FontWeight.w600,
                      shadows: [
                        const Shadow(
                          blurRadius: 25.0,
                          color: Colors.white54,
                          offset: Offset(1.5, 2.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 125.0, top: 25),
                child: Text(
                  "Radio",
                  style: GoogleFonts.badScript(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          )),
    );
  }

}
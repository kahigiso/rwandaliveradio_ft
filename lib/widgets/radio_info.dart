import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import '../pages/home_screen_controller.dart';

class RadioInfo extends StatelessWidget {
  final String url;
  final controller = Get.put(
    HomeScreenController(),
  );

  RadioInfo({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
          borderRadius: BorderRadius.circular(15),
          child: FittedBox(
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  15,
                ),
                color: const Color(0xFF371091).withOpacity(0.75),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: _buildUi(context, controller.getRadioByUrl(url)),
              ),
            ),
          )),
    );
  }

  Widget _buildUi(BuildContext context, RadioModel? radio) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(radio?.name ?? "",
              style: GoogleFonts.actor(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.bold
              ),
          ),
        ),
        SizedBox(
          height: .8,
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(radio?.description ?? "",
              style: GoogleFonts.actor(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12
              ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Source: ${radio?.infoSrc ?? ""}",
            style: GoogleFonts.actor(fontSize: 12, color: Colors.green),
          ),
        ),
        SizedBox(
          height: .8,
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.6)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(radio?.wave ?? "",
                style: GoogleFonts.actor(
                    fontSize: 11,
                  color: Colors.white.withOpacity(0.6),
                ),
            ),
          ),
        ),
      ],
    );
  }
}

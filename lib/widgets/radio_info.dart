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
        const Card(
          elevation: 4,  // Change this
          shadowColor: Colors.grey,  // Change this
          child: Center(child: Text('Hey, dude.')),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(radio?.name ?? "",
              style: GoogleFonts.actor(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: .8,
          child: Container(
            decoration: const BoxDecoration(color: Color(0xFF4831D4)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(radio?.description ?? "",
              style: GoogleFonts.actor(fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Source: ${radio?.infoSrc ?? ""}",
            style: GoogleFonts.actor(fontSize: 12, color: Colors.blue),
          ),
        ),
        SizedBox(
          height: .8,
          child: Container(
            decoration: const BoxDecoration(color: Color(0xFF4831D4)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(radio?.wave ?? "",
                style: GoogleFonts.actor(fontSize: 11, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}

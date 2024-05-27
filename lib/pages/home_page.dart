import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import 'package:rwandaliveradio_fl/pages/home_screen_controller.dart';
import 'package:rwandaliveradio_fl/pages/player_page.dart';
import 'dart:math' as math;

import '../widgets/logo.dart';
import '../widgets/radio_info.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(
    HomeScreenController(),
  );

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _buildUi(context),
    );
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [
                Color(0xFF3A24C2),
                Color(0xFF8775F6),
                Colors.white,
              ],
            ),
          ),
          child: Column(
            children: [
              const Logo(),
              Flexible(
                child: _buildRadioList(
                  context,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioList(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          color: Color(0xFFF3F3F6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), // Adjust the values as needed
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Stack(
            children: [
              ListView.builder(
                itemCount: controller.radios.length,
                itemBuilder: (context, index) {
                  final item = controller.radios[index];
                  return GestureDetector(
                    onTap: () => {
                      controller.onRadioClicked(item.url),
                      Get.toNamed("player")
                    },
                    child: _listItemUi(context, item),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width * 0.045),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 9,
                  width: 1,
                  child: Container(
                    decoration: const BoxDecoration(color: Color(0xFF4831D4)),
                  ),
                ),
              ),
              if(controller.current.value!=null)
                _radioBottomPlayer(context, controller.current.value!)
            ],
          ),
        ));
  }

  Widget _radioBottomPlayer(BuildContext context, RadioModel radio) {
    return Positioned(
        bottom: 15.0,
        right: 0.0,
        child: Container(
            width: MediaQuery.sizeOf(context).width*0.6,
            height: MediaQuery.sizeOf(context).height*0.09,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0), // Adjust the values as needed
                bottomLeft: Radius.circular(30.0),
              ),
              boxShadow: [
                BoxShadow(blurRadius: 25, color: Color(0xFFD6D6D6), spreadRadius:5)
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildAvatarUi(context, radio.img),
                  const SizedBox(width: 16,),
                Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Playing ...",
                          style: GoogleFonts.actor(
                              fontSize: 12, color: const Color(0xFF4831D4)),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          radio.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.actor(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          radio.wave,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.actor(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            )
        )
    );
  }

  Widget _listItemUi(BuildContext context, RadioModel radio) {
    return Padding(
      padding: EdgeInsets.only(
        top: 6.0,
        right: 8.0,
        bottom: 6.0,
        left: MediaQuery.sizeOf(context).width * 0.0225,
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            decoration: const BoxDecoration(
              color: Color(0xFF4831D4),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 25.0,
            height: 1.0,
            decoration: const BoxDecoration(color: Color(0xFF4831D4)),
          ),
          _buildListItemCard(context, radio),
        ],
      ),
    );
  }

  Widget _buildListItemCard(BuildContext context, RadioModel radio) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.82,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: _buildAvatarUi(context, radio.img),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      radio.name,
                      maxLines: 1,
                      style: GoogleFonts.actor(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      radio.wave,
                      style: GoogleFonts.actor(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.dialog(
                            RadioInfo(url: radio.url),
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                        )),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarUi(BuildContext context, String url) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Color(0xFFD6D6D6), spreadRadius: 3)
        ],
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        child: CachedNetworkImage(
          imageUrl: url.trim(),
          width: 50,
          height: 50,
          fit: BoxFit.contain,
          placeholder: (context, url) => const CircularProgressIndicator(
              backgroundColor: Color(0xFFEEEEEE),
              color: Color(0xFFD6D6D6),
              strokeWidth: 2),
          errorWidget: (context, url, error) => Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.red),
              child: const Center(
                  child: Text(
                "RT", //TODO update to abbreviation
                style: TextStyle(fontWeight: FontWeight.w600),
              ))),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Color(0xFF3A24C2),
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
    );
  }
}

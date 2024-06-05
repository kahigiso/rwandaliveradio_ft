import 'dart:async';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import 'package:rwandaliveradio_fl/widgets/avatar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'home_screen_controller.dart';

class PlayerPage extends StatelessWidget {
  final controller = Get.put(
    HomeScreenController(),
  );

  PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3F0C7C), Color(0xFF874FCB), Color(0xFFBB9BF3)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //appBar: _appBar(context),
        body: _buildUi(context),
      ),
    ));
  }

  void animateTo(){
      controller.itemScrollController.value
          ?.scrollTo(
          index: controller
              .indexOfCurrentPlayingRadio(),
          duration: const Duration(
              seconds: 1),
          curve: Curves.fastOutSlowIn);
  }


  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.97,
                  alignment: AlignmentDirectional.topStart,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                Avatar(
                  url: controller.currentPlayingRadio.value?.img ?? "",
                  size: (MediaQuery.sizeOf(context).width * 0.30) / 0.6,
                  radius: MediaQuery.sizeOf(context).width * 0.30,
                  boxShadows: const [
                    BoxShadow(
                        blurRadius: 0, color: Colors.white, spreadRadius: 0)
                  ],
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * 0.02,
                      bottom: MediaQuery.sizeOf(context).height * 0.02,
                    ),
                    child: Column(
                      children: [
                        Text(
                          controller.currentPlayingRadio.value?.shortWave ?? "",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.actor(
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.9)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25.0, top: 8),
                          child: Text(
                            controller.currentPlayingRadio.value?.name ?? "",
                            style: GoogleFonts.actor(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 30),
                          decoration: BoxDecoration(
                              color: const Color(0xFF4A279D).withOpacity(0.60),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: (MediaQuery.sizeOf(context).width *
                                          0.30) /
                                      0.6,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: (!controller.isUnreachable.value)
                                        ? Row(
                                            children: [
                                              Container(
                                                width: 10.0,
                                                height: 10.0,
                                                decoration: BoxDecoration(
                                                  color: (controller
                                                          .isPlaying.value)
                                                      ? Colors.green
                                                          .withOpacity(0.8)
                                                      : Colors.red
                                                          .withOpacity(0.8),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                (controller.isPlaying.value)
                                                    ? "Now live"
                                                    : "Buffering ...",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Container(
                                                width: 10.0,
                                                height: 10.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.red.withOpacity(0.8),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text("Error...",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => {
                                      if (!controller.isFirst())
                                        {
                                          controller.onPrevious(),
                                          animateTo()
                                        }
                                    },
                                    icon: Icon(
                                      Icons.skip_previous_rounded,
                                      size: 40,
                                      color: (!controller.isFirst())
                                          ? Colors.white.withOpacity(0.9)
                                          : Colors.white.withOpacity(0.4),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                      color: const Color(0xFF3B26C9),
                                      onPressed: () =>
                                          {controller.onPlayButtonClicked()},
                                      icon: Icon(
                                        (!controller.isPlaying.value)
                                            ? Icons.play_circle_fill_rounded
                                            : Icons.pause_circle_filled_rounded,
                                        size: 70,
                                        color: Colors.white.withOpacity(0.9),
                                      )),
                                  //Icon(Icons.pause_circle_filled_rounded, size: 70, color: Color(0xFF3B26C9), ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    onPressed: () => {
                                      if (!controller.isLast())
                                        {
                                          controller.onNext(),
                                          animateTo()
                                        }
                                    },
                                    icon: Icon(
                                      Icons.skip_next_rounded,
                                      size: 40,
                                      color: (!controller.isLast())
                                          ? Colors.white.withOpacity(0.9)
                                          : Colors.white.withOpacity(0.4),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        _radioHList(context),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _radioHList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text("More live radio",
                textAlign: TextAlign.start,
                style: GoogleFonts.actor(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                )),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.35,
            height: 4,
            margin: const EdgeInsets.only(top: 8.0, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12.0),
            height: 150,
            child: ScrollablePositionedList.builder(
              itemScrollController: controller.itemScrollController.value,
              scrollDirection: Axis.horizontal,
              itemCount: controller.radios.length,
              itemBuilder: (context, index) {
                final item = controller.radios[index];
                return GestureDetector(
                  onTap: () => {
                    controller.onRadioClicked(item.url),
                  },
                  child: _listItemUi(context, item),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _listItemUi(BuildContext context, RadioModel radio) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.3,
      margin: const EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFF4A279D).withOpacity(0.65),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            child: CachedNetworkImage(
              width: MediaQuery.sizeOf(context).width * 0.3,
              height: MediaQuery.sizeOf(context).height * 0.077,
              imageUrl: radio.img ?? "",
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              radio.name,
              maxLines: 2,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              radio.shortWave ?? "",
              maxLines: 1,
              style: GoogleFonts.roboto(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

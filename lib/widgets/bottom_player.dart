import 'package:flutter/material.dart';

import '../pages/home_screen_controller.dart';
import '../services/theme_handler.dart';
import 'package:get/get.dart';

import 'avatar.dart';

class BottomPlayer extends StatelessWidget {
  final themeController = Get.put(
    ThemeHandler(),
  );
  final HomeScreenController controller;

  BottomPlayer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
        bottom: 15.0,
        right: 0.0,
        child: Container(
            width: MediaQuery.sizeOf(context).width * 0.85,
            height: MediaQuery.sizeOf(context).height * 0.09,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0), // Adjust the values as needed
                bottomLeft: Radius.circular(30.0),
              ),
              boxShadow: (!themeController.isDarkMode())
                  ? <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(0.15),
                          blurRadius: 13.0,
                          offset: const Offset(0, 0))
                    ]
                  : [],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Avatar(url: radio.img),
                  Avatar(
                    url: controller.currentRadio.value!.img,
                    boxShadows: (!themeController.isDarkMode())
                        ? <BoxShadow>[
                            BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withOpacity(0.15),
                                blurRadius: 13.0,
                                offset: const Offset(0, 0))
                          ]
                        : [],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              controller.currentRadio.value!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              controller.currentRadio.value!.wave,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        (controller.isBuffering.value)
                            ?Center(
                              child: SizedBox(
                                height: 25,
                                width: 25,
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 3,
                                  backgroundColor: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ):IconButton(
                            onPressed: () => {
                              controller.onPlay()
                            },
                            icon: Icon(
                              (controller.isPlaying.value)? Icons.pause_circle_filled_rounded: Icons.play_circle_fill_rounded,
                              size: 35,
                            )),
                        IconButton(
                            onPressed: () => {
                              controller.onStop()
                            },
                            icon: const Icon(
                             Icons.stop_circle_rounded,
                              size: 25,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

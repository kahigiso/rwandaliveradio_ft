import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/controllers/home_page_controller.dart';
import '../services/theme_handler.dart';
import '../utils/constants.dart';
import 'avatar.dart';
import 'wave_background.dart';

class BottomPlayer extends StatelessWidget {
  final HomePageController controller = Get.find();
  final ThemeHandler themeHandler = Get.find();

  BottomPlayer({super.key});

  IconData _getPlayerIcon() {
    if (controller.isPlaying) {
      return Icons.pause_circle_filled_rounded;
    } else {
      return Icons.play_circle_fill_rounded;
    }
  }

  void _scrollTo() {
    controller.homeListScrollController.scrollTo(
        index: controller.currentRadioIndex,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn
    );
  }


  @override
  Widget build(BuildContext context) {
    final shadowColor = (themeHandler.isDarkMode())
        ? Theme.of(context).iconTheme.color!.withOpacity(0.05)
        : Theme.of(context).iconTheme.color!.withOpacity(0.2);
    return Obx(
            () =>
            Positioned(
                bottom: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    border: Border(bottom: BorderSide(color: Theme
                        .of(context)
                        .dividerColor, width: 1.5,)),
                    boxShadow: [
                      BoxShadow(
                        color: shadowColor,
                        blurRadius: 20,
                        spreadRadius: 0.3,
                        offset: const Offset(-0, -3.5),
                      )
                    ],
                  ),
          child: Stack(
                    children: [
                        RotatedBox(quarterTurns: 2,
                       child: WaveBackground(height: MediaQuery
                           .sizeOf(context)
                           .height * 0.1)),
                      Container(
                          width: MediaQuery
                              .sizeOf(context)
                              .width,
                          height: MediaQuery
                              .sizeOf(context)
                              .height * 0.1,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Avatar(
                                    url: controller.currentRadio!.img,
                                    boxShadows: (!themeHandler.isDarkMode())
                                        ? <BoxShadow>[
                                      BoxShadow(
                                          color: Theme
                                              .of(context)
                                              .colorScheme
                                              .surface
                                              .withOpacity(0.15),
                                          blurRadius: 13.0,
                                          offset: const Offset(0, 0))
                                    ]
                                        : [],
                                  )),
                              Expanded(
                                flex: 5,
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(Constants.playerScreen)?.then((val)=>{
                                      _scrollTo()
                                    });
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 0),
                                        child: Text(
                                            controller.currentRadio!.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .bodyMedium
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 0),
                                        child: Text(
                                          controller.currentRadio!.wave,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 6,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: [
                                      IconButton(
                                        disabledColor: Theme
                                            .of(context)
                                            .indicatorColor,
                                        onPressed: (controller.isFirst())
                                            ? null
                                            : () =>
                                        {
                                          controller.onPrevious(),
                                          _scrollTo()
                                        },
                                        icon: Icon(
                                          Icons.skip_previous_rounded,
                                          size: 20,
                                          color: (controller.isFirst()) ? null : Theme
                                              .of(context)
                                              .iconTheme
                                              .color,
                                        ),
                                      ),
                                      (controller.isBuffering)
                                          ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(13.0),
                                          child: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                              backgroundColor: Theme
                                                  .of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                          ),
                                        ),
                                      ) : IconButton(
                                          onPressed: () =>
                                          {
                                            controller.onPlay()
                                          },
                                          icon: Icon(
                                            _getPlayerIcon(),
                                            size: 35,
                                          )),

                                      IconButton(
                                        disabledColor: Theme
                                            .of(context)
                                            .indicatorColor,
                                        onPressed: (controller.isLast())
                                            ? null
                                            : () =>
                                        {
                                          controller.onNext(),
                                          _scrollTo()
                                        },
                                        icon: Icon(
                                          Icons.skip_next_rounded,
                                          size: 20,
                                          color: (controller.isLast()) ? null : Theme
                                              .of(context)
                                              .iconTheme
                                              .color,
                                        ),
                                      )
                                    ],
                                  ))
                            ],
                          )),
                    ],
                  ),
                ))
    );
  }

}
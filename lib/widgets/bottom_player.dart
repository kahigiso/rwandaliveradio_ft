import 'package:flutter/material.dart';

import '../pages/home_screen_controller.dart';
import '../services/theme_handler.dart';
import 'package:get/get.dart';

import '../utils/constants.dart';
import 'avatar.dart';

class BottomPlayer extends StatelessWidget {
  final homeController = Get.put(
    HomeScreenController(),
  );
  final themeController = Get.put(
    ThemeHandler(),
  );
  final Function() onNextCallBack;
  final Function() onPrevCallBack;

  BottomPlayer({super.key, required this.onNextCallBack, required this.onPrevCallBack});

  IconData _getPlayerIcon() {
    if (homeController.isPlaying) {
      return Icons.pause_circle_filled_rounded;
    } else {
      return Icons.play_circle_fill_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
        bottom: 0.0,
        right: 0.0,
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.1,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border( bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.5,))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 2,
                    child: Avatar(
                      url: homeController.currentRadio!.img,
                      boxShadows: (!themeController.isDarkMode())
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
                      Get.toNamed(Constants.playerScreen);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          child: Text(
                              homeController.currentRadio!.name,
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
                            homeController.currentRadio!.wave,
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
                          disabledColor: Theme.of(context).indicatorColor,
                          onPressed: (homeController.isFirst())? null : () => {  homeController.onPrevious(), onPrevCallBack },
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 20,
                            color:(homeController.isFirst())? null : Theme.of(context).iconTheme.color,
                          ),
                        ),
                        (homeController.isBuffering)
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
                              homeController.onPlay()
                            },
                            icon: Icon(
                              _getPlayerIcon(),
                              size: 35,
                            )),

                        IconButton(
                          disabledColor: Theme.of(context).indicatorColor,
                          onPressed: (homeController.isLast())? null : () => {  homeController.onNext(), onNextCallBack },
                          icon: Icon(
                            Icons.skip_next_rounded,
                            size: 20,
                            color:(homeController.isLast())? null : Theme.of(context).iconTheme.color,
                          ),
                        )
                      ],
                    ))
              ],
            )));
  }
}

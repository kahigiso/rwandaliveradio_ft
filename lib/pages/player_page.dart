import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import 'package:rwandaliveradio_fl/widgets/avatar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/app_bg.dart';
import 'home_screen_controller.dart';

class PlayerPage extends StatelessWidget {
  final controller = Get.put(
    HomeScreenController(),
  );

  PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBg(
          body: _buildUi(context),
        ));
  }

  void animateTo() {
    controller.itemScrollController.value?.scrollTo(
        index: controller.indexOfCurrentPlayingRadio(),
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn);
  }

  MaterialColor getIndicatorColor(
      DisplayStatusIndicator displayStatusIndicator) {
    switch (displayStatusIndicator) {
      case DisplayStatusIndicator.red:
        {
          return Colors.red;
        }
      case DisplayStatusIndicator.yellow:
        {
          return Colors.yellow;
        }
      default:
        {
          return Colors.green;
        }
    }
  }

  IconData getPlayerIcon() {
    if (controller.isPlaying.value) {
      return Icons.pause_circle_filled_rounded;
    } else {
      return Icons.play_circle_fill_rounded;
    }
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
                    icon: const Icon(
                      Icons.arrow_back,
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
                            controller.currentPlayingRadio.value?.shortWave ??
                                "",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25.0, top: 8),
                          child: Text(
                            controller.currentPlayingRadio.value?.name ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 30),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              SizedBox(
                                  width: (MediaQuery.sizeOf(context).width *
                                          0.30) /
                                      0.6,
                                  child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10.0,
                                            height: 10.0,
                                            decoration: BoxDecoration(
                                              color: getIndicatorColor(
                                                  controller
                                                      .displayStatusIndicator
                                                      .value),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            controller.displayStatus.value.msg,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: () => {
                                      if (!controller.isFirst())
                                        {controller.onPrevious(), animateTo()}
                                    },
                                    icon: Icon(
                                      Icons.skip_previous_rounded,
                                      size: 40,
                                      color: (!controller.isFirst())
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacity(0.9)
                                          : Theme.of(context).indicatorColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  (controller.isBuffering.value && !controller.isError.value)
                                      ?Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child:
                                      CircularProgressIndicator(
                                        strokeWidth: 4,
                                        backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
                                        //valueColor: Colors.red,
                                      ),
                                    ),
                                  ):IconButton(
                                          color: const Color(0xFF3B26C9),
                                          onPressed: () => {
                                                controller.onPlayButtonClicked()
                                              },
                                          icon: Icon(
                                            getPlayerIcon(),
                                            size: 70,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.9),
                                          )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  IconButton(
                                    onPressed: () => {
                                      if (!controller.isLast())
                                        {controller.onNext(), animateTo()}
                                    },
                                    icon: Icon(
                                      Icons.skip_next_rounded,
                                      size: 40,
                                      color: (!controller.isLast())
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withOpacity(0.9)
                                          : Theme.of(context).indicatorColor,
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
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                    )),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.35,
            height: 4,
            margin: const EdgeInsets.only(top: 8.0, bottom: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
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
        color: Theme.of(context).colorScheme.tertiary,
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
              style: Theme.of(context).textTheme.bodyMedium,
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
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

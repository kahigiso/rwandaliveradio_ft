import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import 'package:rwandaliveradio_fl/pages/home_screen_controller.dart';
import '../services/ThemeHandler.dart';
import '../widgets/app_bg.dart';
import '../widgets/top_menu.dart';
import '../widgets/avatar.dart';
import '../widgets/radio_info.dart';
import '../widgets/list_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(
    HomeScreenController(),
  );
  final themeController = Get.put(
    ThemeHandler(),
  );

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBg(
            appBar: _appBar(context),
            body: _buildUi(context),
        ));
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.95,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 8.0),
                      child: Text(
                        "Live radio stations",
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  _buildRadioList(
                    context,
                  ),
                ],
              ),
            ),
          ),
          if (controller.currentPlayingRadio.value != null)
            _radioBottomPlayer(context, controller.currentPlayingRadio.value!),
        ],
      ),
    );
  }

  Widget _buildRadioList(BuildContext context) {
    return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: (controller.loading.value)
            ? SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.6),
                    highlightColor: Colors.grey.withOpacity(0.1),
                    child: const ListShimmer(itemNum:10)
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Stack(children: [
                  const VerticalDivider(
                    //FIXME not visible
                    width: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: controller.radios.length,
                    itemBuilder: (context, index) {
                      final item = controller.radios[index];
                      return GestureDetector(
                        onTap: () async {
                          if (Platform.isAndroid) {
                            PermissionStatus notification =
                                await Permission.notification.request();
                            if (notification == PermissionStatus.granted) {
                              controller.onRadioClicked(item.url);
                              Get.toNamed("player");
                            } else {
                              if (notification == PermissionStatus.denied) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "This permission is required to use this app")));
                              }
                              if (notification ==
                                  PermissionStatus.permanentlyDenied) {
                                openAppSettings();
                              }
                            }
                          } else {
                            controller.onRadioClicked(item.url);
                            Get.toNamed("player");
                          }
                        },
                        child: _listItemUi(context, item),
                      );
                    },
                  ),
                ]),
              ));
  }

  Widget _radioBottomPlayer(BuildContext context, RadioModel radio) {
    return Positioned(
        bottom: 15.0,
        right: 0.0,
        child: Container(
            width: MediaQuery.sizeOf(context).width * 0.8,
            height: MediaQuery.sizeOf(context).height * 0.09,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0), // Adjust the values as needed
                bottomLeft: Radius.circular(30.0),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Avatar(url: radio.img),
                  Avatar(url: radio.img,
                  boxShadows: [
                    BoxShadow(blurRadius: 15,
                        color: Theme.of(context).dividerColor.withAlpha(8),
                        spreadRadius: 5)
                  ],),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10.0,
                              height: 10.0,
                              decoration: BoxDecoration(
                                color: (controller.isPlaying.value)
                                    ? Colors.green.withOpacity(0.8)
                                    : Colors.red.withOpacity(0.8),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(controller.displayStatus.value.msg,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          radio.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                             fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          radio.wave,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
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
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 25.0,
            height: 1.0,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface,),
          ),
          _buildListItemCard(context, radio),
        ],
      ),
    );
  }


  Widget _buildListItemCard(BuildContext context, RadioModel radio) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.82,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Avatar(
                  url: radio.img,
                  boxShadows: [
                    BoxShadow(blurRadius: 15,
                        color: Theme.of(context).dividerColor.withAlpha(8),
                        spreadRadius: 5)
                  ],
              ),
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
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      radio.wave,
                      style: Theme.of(context).textTheme.bodySmall,
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
                    GestureDetector(
                        onTap: () {
                          Get.dialog(
                            RadioInfo(url: radio.url),
                          );
                        },
                        child: const Icon(Icons.more_vert,)),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: TopMenu(children: [
            MenuItem(
                menuTxt: "About",
                icon: const Icon(Icons.info,),
                onTap: () => Get.toNamed("about")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Divider(height: 1, color: Theme.of(context).dividerColor,),
            ),
            MenuItem(
                menuTxt: "Contact",
                icon: const Icon(Icons.contact_page,),
                onTap: () => Get.toNamed("contact")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Divider(height: 1, color: Theme.of(context).dividerColor,),
            ),
            MenuItem(
                menuTxt: "Settings",
                icon: const Icon(Icons.settings,),
                onTap: () => {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text("Settings",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                  ),
                                  ListTile(
                                    trailing: Switch.adaptive(
                                      applyCupertinoTheme: false,
                                      value: themeController.isSavedDarkMode(),
                                      onChanged: (bool value) {
                                        themeController.changeThemeMode((value)? Brightness.dark : Brightness.light);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    title: Text('Dark Theme',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w800
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    child: Divider(height: 1, color: Theme.of(context).dividerColor,),
                                  ),
                                  ListTile(
                                    title: Text('Clear cache',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w800
                                        )
                                    ),
                                    onTap: () => {
                                      Navigator.of(context).pop(),
                                    },
                                  ),
                                ],
                              ),
                            );
                          })
                    })
          ]),
        )
      ],
    );
  }
}


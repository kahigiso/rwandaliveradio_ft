import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import 'package:rwandaliveradio_fl/pages/home_screen_controller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../services/theme_handler.dart';
import '../widgets/app_bg.dart';
import '../widgets/bottom_player.dart';
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
  final  _scrollController = ItemScrollController();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBg(
            appBar: _appBar(context),
            body: _buildUi(context),
        ));
  }


  void navigateToPlayer(RadioModel radio){
    controller.onRadioClicked(radio.url);
    Get.toNamed("player");
    //Implement falback scrool look into FullLifeCycleController
    // Get.toNamed("player") ?.then(
    //         (){
    //   Future.delayed(Duration(seconds: 2));
    //   _scrollController.scrollTo(
    //       index: controller.indexOfCurrentPlayingRadio(),
    //       duration: const Duration(seconds: 1),
    //       curve: Curves.fastOutSlowIn);
    // }
    // )
    // ?.then((val){

   // });
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
                  (controller.dataFetchingFailed.value)? const Text("Data fetching failed try again!"): //FIXME up this to better ui with pull refresh
                  _buildRadioList(
                    context,
                  ),
                ],
              ),
            ),
          ),
          if (controller.currentPlayingRadio.value != null) BottomPlayer(),
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
                  ScrollablePositionedList.builder(
                    shrinkWrap: true,
                    itemScrollController: _scrollController,
                    itemCount: controller.radios.length,
                    itemBuilder: (context, index) {
                      final item = controller.radios[index];
                      return GestureDetector(
                        onTap: () async {
                          if (Platform.isAndroid) {
                            PermissionStatus notification =
                                await Permission.notification.request();
                            if (notification == PermissionStatus.granted) {
                              navigateToPlayer(item);
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
                            navigateToPlayer(item);
                          }
                        },
                        child: _listItemUi(context, item, controller.isCurrent(item)),
                      );
                    },
                  ),
                ]),
              ));
  }

  Widget _listItemUi(BuildContext context, RadioModel radio, bool isCurrent) {
    return Padding(
      padding: EdgeInsets.only(
        top: 6.0,
        right: 8.0,
        bottom: 6.0,
        left: MediaQuery.sizeOf(context).width * 0.0225,
      ),
      child: Row(
        children: [
          Stack(
            alignment:Alignment.center,
            children: [
              RotationTransition(
                turns: const AlwaysStoppedAnimation(30 / 360),
                child: Container(
                  width: 1.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: (!isCurrent)? Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.surfaceDim,
                    boxShadow:(!themeController.isDarkMode())?  <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                          blurRadius: 4.0,
                          offset: const Offset(0, 1)
                      )
                    ]:[],
                  ),
                ),
              ),
              RotationTransition(
                turns: const AlwaysStoppedAnimation(-30 / 360),
                child: Container(
                  width: 1.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: (!isCurrent)? Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.surfaceDim,
                    boxShadow:(!themeController.isDarkMode())?  <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                          blurRadius: 4.0,
                          offset: const Offset(0, 1)
                      )
                    ]:[],
                  ),
                ),
              ),
              RotationTransition(
                turns: const AlwaysStoppedAnimation(60 / 360),
                child: Container(
                  width: 1.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: (!isCurrent)? Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.surfaceDim,
                    boxShadow:(!themeController.isDarkMode())?  <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                          blurRadius: 4.0,
                          offset: const Offset(0, 1)
                      )
                    ]:[],
                  ),
                ),
              ),
              RotationTransition(
                turns: const AlwaysStoppedAnimation(-60 / 360),
                child: Container(
                  width: 1.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: (!isCurrent)? Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.surfaceDim,
                    boxShadow:(!themeController.isDarkMode())?  <BoxShadow>[
                      BoxShadow(
                          color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                          blurRadius: 4.0,
                          offset: const Offset(0, 1)
                      )
                    ]:[],
                  ),
                ),
              ),
              Container(
                width: 1.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: (!isCurrent)? Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.surfaceDim,
                  boxShadow:(!themeController.isDarkMode())?  <BoxShadow>[
                    BoxShadow(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                        blurRadius: 4.0,
                        offset: const Offset(0, 1)
                    )
                  ]:[],
                ),
              ),
              Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  color: (!isCurrent)? Theme.of(context).colorScheme.surface: Theme.of(context).colorScheme.surfaceDim,
                  shape: BoxShape.circle,
                  boxShadow: (!themeController.isDarkMode())? <BoxShadow>[
                    BoxShadow(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                        blurRadius: 4.0,
                        offset: const Offset(0, 1)
                    )
                  ]:[],
                ),
              ),
            ],
          ),

          Container(
            width: 25.0,
            height: 1.0,
            decoration: BoxDecoration(
              color: (!isCurrent)? Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.surfaceDim,
              boxShadow:(!themeController.isDarkMode())?  <BoxShadow>[
                BoxShadow(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
                    blurRadius: 4.0,
                    offset: const Offset(0, 1)
                )
              ]:[],
            ),
          ),


          _buildListItemCard(context, radio, isCurrent),
        ],
      ),
    );
  }


  Widget _buildListItemCard(BuildContext context, RadioModel radio, bool isCurrent) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.82,
      decoration: BoxDecoration(
        color: (!isCurrent)?Theme.of(context).colorScheme.tertiary:Theme.of(context).colorScheme.onTertiary,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: (!themeController.isDarkMode())?   <BoxShadow>[
          BoxShadow(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
              blurRadius: 30.0,
              offset: const Offset(0, 0)
          )
        ]:[],
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
                  boxShadows:(!themeController.isDarkMode())?  [
                    BoxShadow(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.1),
                        blurRadius: 6.0,
                        offset: const Offset(0, 0)
                    )
                  ]:[],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 4, top: 16, bottom: 16),
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
                      height: 15,
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
                        child:  Icon(Icons.more_vert,
                        color: (!isCurrent)? Theme.of(context).iconTheme.color : Theme.of(context).colorScheme.surfaceDim,)),
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
      forceMaterialTransparency: true,
      elevation: 0,
      iconTheme: Theme.of(context).iconTheme,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: TopMenu(children: [
            MenuItem(
                menuTxt: "About",
                icon: const Icon(Icons.info_outline,),
                onTap: () => Get.toNamed("about")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Divider(height: 1, color: Theme.of(context).dividerColor,),
            ),
            MenuItem(
                menuTxt: "Contact",
                icon: const Icon(Icons.contact_page_outlined,),
                onTap: () => Get.toNamed("contact")),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Divider(height: 1, color: Theme.of(context).dividerColor,),
            ),
            MenuItem(
                menuTxt: "Settings",
                icon: const Icon(Icons.settings_outlined,),
                onTap: () => {
                      showModalBottomSheet<dynamic>(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Wrap(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primary,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(30),
                                          topLeft: Radius.circular(30))),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 65,
                                        height: 5,
                                        margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                                        decoration:  BoxDecoration(
                                            color: Theme.of(context).colorScheme.surface,
                                            borderRadius: const BorderRadius.all(Radius.circular(2),),
                                        ),

                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Text("Settings",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            )
                                        ),
                                      ),
                                      ListTile(
                                        trailing: Switch.adaptive(
                                          value: themeController.isDarkMode(),
                                          onChanged: (bool value) {
                                            themeController.changeThemeMode(value);
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
                                      const SizedBox(height: 45,)
                                    ],
                                  ),
                                ),
                              ],
                            );
                          })
                    })
          ]),
        )
      ],
    );
  }
}


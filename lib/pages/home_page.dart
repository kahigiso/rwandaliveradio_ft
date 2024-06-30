import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import 'package:rwandaliveradio_fl/pages/controllers/home_page_controller.dart';
import 'package:rwandaliveradio_fl/widgets/nav_bar.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../models/screen_state.dart';
import '../services/theme_handler.dart';
import '../utils/constants.dart';
import '../widgets/app_bg.dart';
import '../widgets/avatar.dart';
import '../widgets/radio_info.dart';
import '../widgets/list_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  final HomePageController controller = Get.find();
  final ThemeHandler themeHandler = Get.find();

  HomePage({super.key});

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


  void _navigateToPlayer(int? index) {
    if(index != null) controller.onPlayRadio(index);
    Get.toNamed(Constants.playerScreen)?.then((val)=>{
      _scrollTo()
    });
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBg(
          endDrawer: NavBar(
              isSettingExpanded: controller.isSettingExpanded,
              isPlaying: controller.isPlaying,
              onSettingTap: () => controller.expandedSetting(),
              favoriteCount: controller.favoritesCount),
          onEndDrawerChanged: (isOpen) {
            controller.onEndDrawerClose();
          },
          appBar: _appBar(context),
          body: SafeArea(
            child: Stack(
              children: [
                if (controller.state is LoadingState) _showLoading(context),
                if (controller.state is LoadedState)
                  _showRadioList(context),
                if (controller.state is ErrorState) _showError(context),
                if (controller.currentRadio != null)
                  _showBottomPlayer(context),
              ],
            ),
          ),
        )
    );
  }

  Widget _showRadioList(BuildContext context,){
    return ScrollablePositionedList.builder(
        shrinkWrap: true,
        initialScrollIndex: controller.currentRadioIndex,
        itemScrollController: controller.homeListScrollController,
        itemPositionsListener: controller.homeItemPositionsListener,
        itemCount: (controller.state as LoadedState).data.length,
        itemBuilder: (context, index) {
          if(index == 0 ){
            return Container(
              alignment: Alignment.bottomLeft,
              width: MediaQuery
                  .sizeOf(context)
                  .width * 0.95,
              height: MediaQuery
                  .sizeOf(context)
                  .height * 0.125,
              margin: const EdgeInsets.only(left: 16,bottom: 25, right: 18),
              child: AnimatedOpacity(
                  opacity: (controller.showHeaderTitle) ? 0 : 1,
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    "Live radio",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
            );
          }
          index -= 1;
          final item = controller.getRadioForIndex(index);
          return GestureDetector(
            onTap: () async {
              if (Platform.isAndroid) {
                PermissionStatus notification =
                await Permission.notification.request();
                if (notification == PermissionStatus.granted) {
                  _navigateToPlayer(index);
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
                _navigateToPlayer(index);
              }
            },
            child: _listItemUi(context, item, index),
          );
        },
      );
  }

  Widget _showLoading(BuildContext context,){
    return  Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.grey.withOpacity(0.1),
        child: const ListShimmer(itemNum: 8));
  }

  Widget _showError(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Error has happened try again later.", style: Theme
          .of(context)
          .textTheme
          .bodySmall,),
    );
  }


  Widget _listItemUi(BuildContext context, RadioModel radio, int index) {
    return Padding(
      padding: EdgeInsets.only(
        top: 6.0,
        right: 8.0,
        bottom: 6.0,
        left: MediaQuery
            .sizeOf(context)
            .width * 0.0225,
      ),
      child: Row(
        children: [
          Stack(
            alignment:Alignment.center,
            children: [
              Container(
                width: 1.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: (!controller.isCurrent(index))? Theme.of(context).colorScheme.surface:Theme.of(context).colorScheme.surfaceDim,
                  boxShadow:(!themeHandler.isDarkMode())?  <BoxShadow>[
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
                  color: (!controller.isCurrent(index))
                      ? Theme
                      .of(context)
                      .colorScheme
                      .surface
                      : Theme
                      .of(context)
                      .colorScheme
                      .surfaceDim.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: (!themeHandler.isDarkMode())
                      ? <BoxShadow>[
                    BoxShadow(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.6),
                        blurRadius: 4.0,
                        offset: const Offset(0, 1))
                  ]
                      : [],
                ),
              ),
          ],),
          Container(
            width: 25.0,
            height: 1.0,
            decoration: BoxDecoration(
              color: (!controller.isCurrent(index))
                  ? Theme
                  .of(context)
                  .colorScheme
                  .surface
                  : Theme
                  .of(context)
                  .colorScheme
                  .surfaceDim.withOpacity(0.8),
              boxShadow: (!themeHandler.isDarkMode())
                  ? <BoxShadow>[
                BoxShadow(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .surface
                        .withOpacity(0.6),
                    blurRadius: 4.0,
                    offset: const Offset(0, 1))
              ]
                  : [],
            ),
          ),
          _buildListItemCard(context, radio, index),
        ],
      ),
    );
  }

  Widget _buildListItemCard(BuildContext context, RadioModel radio, int index) {
    return Container(
      width: MediaQuery
          .sizeOf(context)
          .width * 0.82,
      height: MediaQuery
          .sizeOf(context)
          .height * 0.125,
      decoration: BoxDecoration(
        color: (!controller.isCurrent(index))
            ? Theme
            .of(context)
            .colorScheme
            .tertiary
            : Theme
            .of(context)
            .colorScheme
            .onTertiary.withOpacity(0.8),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: (!themeHandler.isDarkMode())
            ? <BoxShadow>[
          BoxShadow(
              color:
              Theme
                  .of(context)
                  .colorScheme
                  .surface
                  .withOpacity(0.1),
              blurRadius: 30.0,
              offset: const Offset(0, 0))
        ]
            : [],
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
                boxShadows: (!themeHandler.isDarkMode())
                    ? [
                  BoxShadow(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.1),
                      blurRadius: 6.0,
                      offset: const Offset(0, 0))
                ]
                    : [],
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 4, top: 5, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      radio.name,
                      maxLines: 1,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      radio.wave,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall,
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
                        child: Icon(
                          Icons.more_vert,
                          color: Theme
                              .of(context)
                              .iconTheme
                              .color,
                        )),
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _showBottomPlayer(BuildContext context){
    final shadowColor = (themeHandler.isDarkMode())
        ? Theme.of(context).iconTheme.color!.withOpacity(0.1)
        : Theme.of(context).iconTheme.color!.withOpacity(0.3);
    return  Positioned(
        bottom: 0.0,
        right: 0.0,
        child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 0.1,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border( bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.5,)),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 25,
                  spreadRadius: 1,
                  offset: const Offset(-0, -3.5),
                )
              ],
            ),
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
                      _navigateToPlayer(null);
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
                          disabledColor: Theme.of(context).indicatorColor,
                          onPressed: (controller.isFirst())? null : () => {  controller.onPrevious(), _scrollTo() },
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 20,
                            color:(controller.isFirst())? null : Theme.of(context).iconTheme.color,
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
                          disabledColor: Theme.of(context).indicatorColor,
                          onPressed: (controller.isLast())? null : () => {  controller.onNext(), _scrollTo() },
                          icon: Icon(
                            Icons.skip_next_rounded,
                            size: 20,
                            color:(controller.isLast())? null : Theme.of(context).iconTheme.color,
                          ),
                        )
                      ],
                    ))
              ],
            )));
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      forceMaterialTransparency: true,
      elevation: 0,
      iconTheme: Theme
          .of(context)
          .iconTheme,
      centerTitle: false,
      title:  AnimatedOpacity(
          opacity: (controller.showHeaderTitle) ? 1 : 0,
          duration: const Duration(milliseconds: 800),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Image.asset(
                  color: Theme
                      .of(context)
                      .dividerColor.withOpacity(0.9),
                    width:40,
                    height:40,
                    'assets/images/logo.png'
                ),
              ),
              const SizedBox(width: 10,),
              Text("Live radio", style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 25
              )),
            ],
          )),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.only(right: 18.0),
      //     child: TopMenu(children: [
      //       MenuItem(
      //           menuTxt: "About",
      //           icon: const Icon(
      //             Icons.info_outline,
      //           ),
      //           onTap: () => Get.toNamed(Constants.aboutScreen)),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      //         child: Divider(
      //           height: 1,
      //           color: Theme
      //               .of(context)
      //               .dividerColor,
      //         ),
      //       ),
      //       MenuItem(
      //           menuTxt: "Contact",
      //           icon: const Icon(
      //             Icons.contact_page_outlined,
      //           ),
      //           onTap: () => Get.toNamed(Constants.contactScreen)),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      //         child: Divider(
      //           height: 1,
      //           color: Theme
      //               .of(context)
      //               .dividerColor,
      //         ),
      //       ),
      //       MenuItem(
      //           menuTxt: "Settings",
      //           icon: const Icon(
      //             Icons.settings_outlined,
      //           ),
      //           onTap: () =>
      //           {
      //             showModalBottomSheet<dynamic>(
      //                 backgroundColor: Colors.transparent,
      //                 context: context,
      //                 builder: (context) {
      //                   return Wrap(
      //                     children: [
      //                       Container(
      //                         decoration: BoxDecoration(
      //                             color:
      //                             Theme
      //                                 .of(context)
      //                                 .colorScheme
      //                                 .primary,
      //                             borderRadius: const BorderRadius.only(
      //                                 topRight: Radius.circular(30),
      //                                 topLeft: Radius.circular(30))),
      //                         child: Column(
      //                           children: [
      //                             Container(
      //                               width: 65,
      //                               height: 5,
      //                               margin: const EdgeInsets.symmetric(
      //                                   vertical: 10, horizontal: 0),
      //                               decoration: BoxDecoration(
      //                                 color: Theme
      //                                     .of(context)
      //                                     .colorScheme
      //                                     .surface,
      //                                 borderRadius: const BorderRadius.all(
      //                                   Radius.circular(2),
      //                                 ),
      //                               ),
      //                             ),
      //                             Padding(
      //                               padding: const EdgeInsets.symmetric(
      //                                   vertical: 10.0),
      //                               child: Text("Settings",
      //                                   style: Theme
      //                                       .of(context)
      //                                       .textTheme
      //                                       .bodyMedium
      //                                       ?.copyWith(
      //                                       fontSize: 20,
      //                                       fontWeight:
      //                                       FontWeight.bold)),
      //                             ),
      //                             ListTile(
      //                               trailing: Switch.adaptive(
      //                                 value: themeController.isDarkMode(),
      //                                 onChanged: (bool value) {
      //                                   themeController
      //                                       .changeThemeMode(value);
      //                                 },
      //                               ),
      //                               title: Text('Dark Theme',
      //                                   style: Theme
      //                                       .of(context)
      //                                       .textTheme
      //                                       .bodyMedium
      //                                       ?.copyWith(
      //                                       fontWeight:
      //                                       FontWeight.w800)),
      //                             ),
      //                             Padding(
      //                               padding: const EdgeInsets.symmetric(
      //                                   horizontal: 8, vertical: 0),
      //                               child: Divider(
      //                                 height: 1,
      //                                 color: Theme
      //                                     .of(context)
      //                                     .dividerColor,
      //                               ),
      //                             ),
      //                             ListTile(
      //                               title: Text('Clear cache',
      //                                   style: Theme
      //                                       .of(context)
      //                                       .textTheme
      //                                       .bodyMedium
      //                                       ?.copyWith(
      //                                       fontWeight:
      //                                       FontWeight.w800)),
      //                               onTap: () =>
      //                               {
      //                                 Navigator.of(context).pop(),
      //                               },
      //                             ),
      //                             const SizedBox(
      //                               height: 45,
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   );
      //                 })
      //           })
      //     ]),
      //   )
      // ],
    );
  }
}

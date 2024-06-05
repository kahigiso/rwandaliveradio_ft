import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';
import 'package:rwandaliveradio_fl/models/radio_model.dart';
import 'package:rwandaliveradio_fl/pages/home_screen_controller.dart';
import '../widgets/top_menu.dart';
import '../widgets/avatar.dart';
import '../widgets/radio_info.dart';
import '../widgets/list_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(
    HomeScreenController(),
  );

  HomePage({super.key});

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
            appBar: _appBar(context),
            body: _buildUi(context),
          ),
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
                        style: GoogleFonts.actor(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
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
              color: const Color(0xFF4A279D).withOpacity(0.95),
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
                  Avatar(url: radio.img, boxShadows: const [
                    BoxShadow(
                        blurRadius: 0,
                        color: Color(0xFFD6D6D6),
                        spreadRadius: 0)
                  ]),
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
                            Text(
                              (controller.isPlaying.value)
                                  ? "Now live"
                                  : "Buffering ...",
                              style: GoogleFonts.roboto(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 11,
                              ),
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
                          style: GoogleFonts.actor(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
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
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w300),
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
            decoration: const BoxDecoration(
              color: Color(0xFF4A279D),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 25.0,
            height: 1.0,
            decoration: const BoxDecoration(color: Color(0xFF4A279D)),
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
        color: const Color(0xFF4A279D).withOpacity(0.65),
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
              child: Avatar(url: radio.img, boxShadows: const [
                BoxShadow(
                    blurRadius: 0, color: Color(0xFFD6D6D6), spreadRadius: 0)
              ]),
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
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      radio.wave,
                      style: GoogleFonts.actor(
                          fontSize: 12,
                          color: Colors.white60,
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
                    GestureDetector(
                        onTap: () {
                          Get.dialog(
                            RadioInfo(url: radio.url),
                          );
                        },
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
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
      actionsIconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: TopMenu(children: [
            MenuItem(
                menuTxt: "About",
                icon: const Icon(
                  Icons.info,
                  color: Color(0xFF3F0C7C),
                ),
                onTap: () => Get.toNamed("about")),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Divider(height: 1),
            ),
            MenuItem(
                menuTxt: "Contact",
                icon: const Icon(
                  Icons.contact_page,
                  color: Color(0xFF3F0C7C),
                ),
                onTap: () => Get.toNamed("contact")),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Divider(height: 1),
            ),
            MenuItem(
                menuTxt: "Settings",
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xFF3F0C7C),
                ),
                onTap: () => {
                      Navigator.of(context).pop(),
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF7E57C2).withOpacity(0.90),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text("Settings",
                                        style: GoogleFonts.actor(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white)),
                                  ),
                                  ListTile(
                                    trailing: Switch.adaptive(
                                      applyCupertinoTheme: false,
                                      value: controller.isDark.value,
                                      onChanged: (bool value) {
                                        controller.changeTheme(value);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    title: Text('Dark Theme',
                                        style: GoogleFonts.actor(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white)),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    child: Divider(height: 1),
                                  ),
                                  ListTile(
                                    title: Text('Clear cache',
                                        style: GoogleFonts.actor(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white)),
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


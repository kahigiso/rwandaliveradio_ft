import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../services/theme_handler.dart';
import '../utils/constants.dart';

class NavBar extends StatelessWidget {
  final themeController = Get.put(ThemeHandler());
  final bool isSettingExpanded;
  final bool isPlaying;
  final int favoriteCount;
  final VoidCallback onSettingTap;

  NavBar(
      {super.key,
      required this.isSettingExpanded,
      required this.isPlaying,
      required this.onSettingTap,
      required this.favoriteCount});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Material(
        color: Theme.of(context).primaryColor,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
          children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              "assets/images/logo.png",
              width: 100,
              height: 100,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(
              height: 30,
            ),
            _menuTile(
              context: context,
              leadingIcon: Icons.home_outlined,
              title: "Home",
              shouldDismiss: true,
              onTap: () {},
            ),
            _menuTile(
                context: context,
                leadingIcon: Icons.info_outline,
                title: "About",
                onTap: () => Get.toNamed(Constants.aboutScreen)),
            if (favoriteCount > 0)
              _menuTile(
                  context: context,
                  leadingIcon: Icons.favorite_outline,
                  title: "Favorite",
                  trailing: ClipOval(
                    child: Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      color: Colors.red,
                      child: Text(
                        "9",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  onTap: () => Get.toNamed(Constants.aboutScreen)),
            if (isPlaying)
              _menuTile(
                  context: context,
                  leadingIcon: Icons.radio_outlined,
                  title: "Go player",
                  onTap: () => Get.toNamed(Constants.playerScreen)),
            _menuTile(
                context: context,
                leadingIcon: Icons.contact_page_outlined,
                title: "Contact",
                onTap: () => Get.toNamed(Constants.contactScreen)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            _menuTile(
                context: context,
                leadingIcon: Icons.share_outlined,
                title: "Share",
                onTap: () => Share.share('www.google.com')),
            Builder(builder: (context) {
              return ExpansionTile(
                leading: Icon(
                  Icons.settings_outlined,
                  size: 20,
                  color: Theme.of(context).colorScheme.outline,
                ),
                title: Text("Settings",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
                trailing: Icon(
                  !isSettingExpanded
                      ? Icons.arrow_circle_down_outlined
                      : Icons.arrow_circle_up_outlined,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onExpansionChanged: (bool isExpanded) {
                  onSettingTap.call();
                },
                children: [
                  _menuTile(
                      context: context,
                      title: "Dark theme",
                      trailing: Switch(
                        value: themeController.isDarkMode(),
                        onChanged: (bool value) {
                          themeController.changeThemeMode(value);
                        },
                      ),
                      onTap: () {}),
                  _menuTile(
                      context: context,
                      title: "Clear cache",
                      onTap: () => print("Clear cache is clicked")),
                ],
              );
            }),
            _menuTile(
                context: context,
                leadingIcon: Icons.exit_to_app_outlined,
                title: "Exit",
                onTap: () => exit(0)),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(
      {required BuildContext context,
      IconData? leadingIcon,
      required String title,
      Widget? trailing,
      bool shouldDismiss = true,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: () {
        if (shouldDismiss) Navigator.pop(context);
        onTap?.call();
      },
      child: ListTile(
          leading: Icon(
            leadingIcon,
            size: 20,
          ),
          title: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
          trailing: trailing),
    );
  }
}

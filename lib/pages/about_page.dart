
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_bg.dart';
import '../widgets/bottom_player.dart';
import 'controllers/home_page_controller.dart';

class AboutPage extends StatelessWidget {
  final HomePageController controller = Get.find();
  AboutPage({super.key});

  @override
  Widget build(BuildContext context) {

    return  AppBg(
        body:  Stack(
          children: [
            const Center(
              child: Text("About"),
            ),
            if (controller.currentRadio != null) BottomPlayer()
          ],
        ),
    );
  }
}

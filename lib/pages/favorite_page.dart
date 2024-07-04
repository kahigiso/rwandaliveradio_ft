import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_bg.dart';
import '../widgets/bottom_player.dart';
import 'controllers/home_page_controller.dart';

class FavoritePage extends StatelessWidget {
  final HomePageController controller = Get.find();

  FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppBg(
          body: Stack(
            children: [
              Center(
                child: Text("Favorite ${controller.favoritesCount}"),
              ),
              if (controller.currentRadio != null) BottomPlayer()
            ],
          ),
        ));
  }
}

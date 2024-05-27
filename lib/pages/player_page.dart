import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen_controller.dart';

class PlayerPage extends StatelessWidget {
  final controller = Get.put(
    HomeScreenController(),
  );

  PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3A24C2),
      ),
      body:_buildUi(context),
    );
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              colors: [
                Color(0xFF3A24C2),
                Color(0xFF8775F6),
                Colors.white,
              ],
            ),
          ),
          child:  Column(
            children: [
              Center(child: Text("Current radio: ${controller.current.value?.name ?? ""}")),
            ],
          ),
        ),
      ),
    );
  }
}

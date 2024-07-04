import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rwandaliveradio_fl/pages/about_page.dart';
import 'package:rwandaliveradio_fl/pages/contact_us_page.dart';
import 'package:rwandaliveradio_fl/pages/favorite_page.dart';
import 'package:rwandaliveradio_fl/pages/home_page.dart';
import 'package:rwandaliveradio_fl/pages/player_page.dart';
import 'package:rwandaliveradio_fl/services/theme_handler.dart';
import 'package:rwandaliveradio_fl/utils/constants.dart';
import 'package:rwandaliveradio_fl/di/dependency_injection.dart';
import 'themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle().copyWith(
    statusBarColor: Colors.transparent,
  ));
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });
  await registerServices();
  runApp(RwandaLiveRadioApp());
}
class RwandaLiveRadioApp extends StatelessWidget {
  RwandaLiveRadioApp({super.key});
  final themeController = Get.put(
    ThemeHandler(),
  );
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rwanda Live Radio',
      themeMode: themeController.getThemeMode(),
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      debugShowCheckedModeBanner: false,
      routes: {
        "/${Constants.homeScreen}": (context) => HomePage(),
        Constants.playerScreen: (context) => PlayerPage(),
        Constants.aboutScreen: (context) =>  AboutPage(),
        Constants.contactScreen: (context) => ContactUsPage(),
        Constants.favoriteScreen: (context) => FavoritePage(),
      },
      initialRoute: "/${Constants.homeScreen}",
    );
  }
}

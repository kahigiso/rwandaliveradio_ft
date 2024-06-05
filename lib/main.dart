import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rwandaliveradio_fl/pages/about_page.dart';
import 'package:rwandaliveradio_fl/pages/contact_page.dart';
import 'package:rwandaliveradio_fl/pages/home_page.dart';
import 'package:rwandaliveradio_fl/pages/player_page.dart';
import 'package:rwandaliveradio_fl/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    return true;
  });
  await registerService();
  runApp(const RwandaLiveRadioApp());
}
class RwandaLiveRadioApp extends StatelessWidget {
  const RwandaLiveRadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rwanda Live Radio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        textTheme: GoogleFonts.robotoTextTheme(),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // getPages: [
      //   GetPage(name: '/home', page:  () => HomePage()),
      //   GetPage(name: '/player', page: () => PlayerPage(), transition: Transition.fade),
      // ],
      routes: {
        "/home": (context) => HomePage(),
        "player": (context) => PlayerPage(),
        "contact": (context) => const ContactPage(),
        "about": (context) => const AboutPage(),
      },
      initialRoute: "/home",
    );
  }
}



// void main() async {
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
//   runApp(const RwandaLiveRadioApp());
// }
//
// class RwandaLiveRadioApp extends StatefulWidget {
//   const RwandaLiveRadioApp({super.key});
//   @override
//   SplashScreen createState() => SplashScreen();
// }
// class SplashScreen extends State<RwandaLiveRadioApp> {
//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }
//
//   void initialize() async {
//     print("pausing...");
//     await Future.delayed(const Duration(seconds: 10));
//     print("unpausing...");
//     FlutterNativeSplash.remove();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  const MaterialApp(
//       title: 'Rwanda Live Radio',
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: Colors.red,
//         body: Center(child: Text("app here"),),
//       )
//     );
//   }
//
// }

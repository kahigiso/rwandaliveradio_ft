import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rwandaliveradio_fl/pages/home_page.dart';
import 'package:rwandaliveradio_fl/pages/player_page.dart';
import 'package:rwandaliveradio_fl/utils/utils.dart';
import 'dart:math' as math;

void main() async {
  await registerService();
  runApp(const RwandaLiveRadioApp());
}
class RwandaLiveRadioApp extends StatelessWidget {
  const RwandaLiveRadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF3A24C2), //or set color with: Color(0xFF0000FF)
    ));
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
      },
      initialRoute: "/home",
    );
  }
}



// class RwandaLiveRadioApp extends StatefulWidget {
//   const RwandaLiveRadioApp({super.key});
//   @override
//   SplashScreen createState() => SplashScreen();
// }
// class SplashScreen extends State<RwandaLiveRadioApp> {
//   @override
//   void initState() {
//     super.initState();
//     hideScreen();
//     Get.toNamed("home");
//   }
//
//   ///hide your splash screen
//   Future<void> hideScreen() async {
//     Future.delayed(const Duration(milliseconds: 3600), () {
//       FlutterSplashScreen.hide();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  GetMaterialApp(
//       title: 'Rwanda Live Radio',
//       debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
//         textTheme: GoogleFonts.robotoTextTheme(),
//         useMaterial3: true,
//       ),
//       routes: {
//         //"/splash": (context) => HomePage(),
//         "/home": (context) => HomePage(),
//       },
//       //initialRoute: "/splash",
//       home: Scaffold(
//         body: Container(
//         decoration: const BoxDecoration(
//           color: Color(0xFF3A24C2),
//         ),
//           child: Center(
//             child: _buildLogo(context),
//           ),
//         ),
//       ),
//     );
//   }
//
// }

import 'package:flutter/material.dart';

import '../widgets/app_bg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {

    return  const AppBg(
        body:  SafeArea(child: Center(child: Text("About"),)),
    );
  }
}

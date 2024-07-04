import 'package:flutter/material.dart';

import 'wave_background.dart';

class AppBg extends StatelessWidget {
  final Widget? endDrawer;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final DrawerCallback? onEndDrawerChanged;

  const AppBg(
      {super.key,
      this.appBar,
      required this.body,
      this.endDrawer,
      this.onEndDrawerChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Scaffold(
        endDrawer: endDrawer,
        onEndDrawerChanged: onEndDrawerChanged,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: SafeArea(
          child: Stack(children: [
            Positioned(bottom: 0, child: WaveBackground(height: 400)),
            body
          ]),
        ),
      ),
    );
  }
}
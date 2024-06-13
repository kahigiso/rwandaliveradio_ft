import 'package:flutter/material.dart';

class AppBg extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  const AppBg({super.key, this.appBar, this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color:  Theme.of(context).colorScheme.primary,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
      ),
    );
  }
}

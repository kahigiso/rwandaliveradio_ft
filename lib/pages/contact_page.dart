import 'package:flutter/material.dart';

import '../widgets/app_bg.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const AppBg(
        body:  SafeArea(child: Center(child: Text("Contact"),)),
    );
  }
}

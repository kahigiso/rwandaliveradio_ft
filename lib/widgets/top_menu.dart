import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popover/popover.dart';

class TopMenu extends StatelessWidget {
  final List<Widget> children;

  const TopMenu({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Icon(Icons.more_vert),
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.20,
            child: Column(
              children: children,
            ),
          ),
          direction: PopoverDirection.bottom,
          arrowHeight: 10,
          arrowWidth: 15,
          backgroundColor: const Color(0xFF7E57C2).withOpacity(0.85),
        );
      },
    );
  }
}

class MenuItem extends StatelessWidget {
  final String menuTxt;
  final Icon icon;
  final Function onTap;

  const MenuItem({
    super.key,
    required this.menuTxt,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.065,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => onTap(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                menuTxt,
                style: GoogleFonts.actor(
                  fontSize: 18,
                    fontWeight: FontWeight.w800, color: Colors.white),
              ),
              icon
            ],
          ),
        ),
      ),
    );
  }
}

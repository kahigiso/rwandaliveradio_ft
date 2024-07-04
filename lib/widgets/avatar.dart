import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String url;
  final double size;
  final double radius;
  final List<BoxShadow> boxShadows;

  const Avatar(
        {
          super.key,
          required this.url,
          this.radius = 30,
          this.size = 50,
          this.boxShadows = const [BoxShadow(blurRadius: 10, color: Color(0xFFD6D6D6), spreadRadius: 3)]
        }
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: boxShadows,
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: CachedNetworkImage(
          imageUrl: url,
          width: size,
          height: size,
          fit: BoxFit.contain,
          placeholder: (context, url) => const CircularProgressIndicator(
              backgroundColor: Color(0xFFEEEEEE),
              color: Color(0xFFD6D6D6),
              strokeWidth: 2),
          errorWidget: (context, url, error) => Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.cover,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height * 0.22); // Start at top-left

    var firstControlPoint = Offset(size.width * 0.25, size.height * 0.7);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.45);

    var secondControlPoint = Offset(size.width * 0.75, size.height * 0.15);
    var secondEndPoint = Offset(size.width, size.height * 0.12);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height); // Line to bottom-right
    path.lineTo(0, size.height); // Line to bottom-left

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
import 'package:flutter/material.dart';

class CustomClip extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0.0, 0.0, 200.0, 300.0);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }

}
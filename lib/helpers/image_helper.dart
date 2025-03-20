import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RadiorLocal {
  static SvgPicture svg(  
    String asset, {
      double? width,
      double? height,
      BoxFit fit = BoxFit.none,
      AlignmentGeometry alignment = Alignment.center,
    }) {
    return SvgPicture.asset(
      'assets/images/$asset',
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }
}
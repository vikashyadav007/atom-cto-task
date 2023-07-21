import 'package:flutter/material.dart';

class MyColors {
  static const mainBlack = 0xff000000;
  static const mainGolder = 0xffEDBA55;
  static const mainWhite = 0xffFFFFFF;
  static const bottomNavigationBarColor = 0xff0D1721;
  static const bottomNavigationBarColor2 = 0xff1A2A3B;
  static const someShadeOfBlue = 0xff29425B;

  static const MaterialColor primaryBlack = MaterialColor(
    mainBlack,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(mainBlack),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
}

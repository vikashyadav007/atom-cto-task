import 'package:atom_cto_task/utils/colors.dart';
import 'package:flutter/material.dart';

class MyWidgets {
  static Widget getTextView(
      {required String title,
      double size = 17,
      FontWeight fontWeight = FontWeight.w400,
      Color color = Colors.black,
      TextAlign textAlign = TextAlign.left}) {
    return Text(
      title,
      style: TextStyle(fontSize: size, color: color, fontWeight: fontWeight),
      softWrap: true,
      textAlign: textAlign,
    );
  }

  static Widget customCircularProgressBar = const Center(
    child: CircularProgressIndicator(
      backgroundColor: Color(MyColors.mainWhite),
      valueColor: AlwaysStoppedAnimation<Color>(Color(MyColors.mainBlack)),
    ),
  );
}

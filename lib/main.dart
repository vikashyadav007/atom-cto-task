import 'package:atom_cto_task/screens/home.dart';
import 'package:atom_cto_task/utils/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Atom CTO',
      theme: ThemeData(
        primarySwatch: MyColors.primaryBlack,
        fontFamily: "SpaceGrotesk",
      ),
      home: Home(),
    ),
  );
}

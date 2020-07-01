import 'package:flutter/material.dart';

var bgGradient = new LinearGradient(
  colors: [Colors.white, Colors.white],
  tileMode: TileMode.clamp,
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  stops: [0.0, 1.0],
);

var btnGradient = new LinearGradient(
  colors: [Color(0xff4dd0e1), Color(0xff00acc1)],
  tileMode: TileMode.clamp,
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  stops: [0.0, 1.0],
);

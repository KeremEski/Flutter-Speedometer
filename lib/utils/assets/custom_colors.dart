import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomColors {
  static final CustomColors _instance = CustomColors._internal();

  factory CustomColors() {
    return _instance;
  }

  CustomColors._internal();

  final Color primaryColor = HexColor("#0F0E38");
  final Color secondaryColor = HexColor("#FFFFFF");
  final Color lightColor1 = HexColor("#FFFFFF");
  final Color lightColor2 = HexColor("#C2E5FF");
  final Color lightColor3 = HexColor("#FF0202");
  final Color darkColor1 = HexColor("#000000");
  final Color darkColor2 = HexColor("#444444");
  final Color darkColor3 = HexColor("#757575");
}

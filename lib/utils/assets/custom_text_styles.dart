import 'package:car_multimedia/utils/assets/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomTextStyles {
  static final CustomTextStyles _instance = CustomTextStyles._internal();

  factory CustomTextStyles() {
    return _instance;
  }

  CustomTextStyles._internal();

  TextStyle p1(Color? color) {
    return TextStyle(
        fontFamily: "Michroma",
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: color ?? CustomColors().darkColor1);
  }

  TextStyle p2(Color? color) {
    return TextStyle(
        fontFamily: "Michroma",
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: color ?? CustomColors().darkColor3);
  }

  TextStyle p2Bold(Color? color) {
    return TextStyle(
        fontFamily: "Michroma",
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: color ?? CustomColors().darkColor3);
  }

  TextStyle p3(Color? color) {
    return TextStyle(
        fontFamily: "Michroma",
        fontWeight: FontWeight.w400,
        fontSize: 10,
        color: color ?? CustomColors().darkColor3);
  }

  TextStyle h3(Color? color) {
    return TextStyle(
        fontFamily: "Michroma",
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: color ?? CustomColors().darkColor2);
  }

  TextStyle h2(Color? color) {
    return TextStyle(
        fontFamily: "Michroma",
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: color ?? CustomColors().darkColor1);
  }

  TextStyle h1(Color? color) {
    return TextStyle(
        fontFamily: "Michroma",
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: color ?? CustomColors().darkColor1);
  }
}


import 'package:flutter/material.dart';

class MyAppText {
  static Widget title(String text,
      {Color? color, TextDecoration? textDecoration, double? size, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: size ?? 20,
          fontWeight: FontWeight.bold,
          color: color,
          decoration: textDecoration),
    );
  }

  static Widget subtitle(String text,
      {Color? color, TextDecoration? textDecoration, double? size, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: size ?? 18,
          fontWeight: FontWeight.w500,
          color: color,
          decoration: textDecoration),
    );
  }

  static Widget normal(String text,
      {Color? color, TextDecoration? textDecoration, double? size, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          fontSize: size ?? 16,
          fontWeight: FontWeight.normal,
          color: color,
          decoration: textDecoration),
    );
  }
}

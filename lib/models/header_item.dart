import 'package:flutter/material.dart';

class NameOnTap {
  final String title;
  final IconData? iconData;
  final Widget? widget;
  final VoidCallback onTap;
  final bool? isDarkTheme;

  NameOnTap({
    required this.title,
    required this.onTap,
    this.iconData,
    this.isDarkTheme,
    this.widget,
  });
}

import 'package:flutter/material.dart';

Widget RenderWidget(
    {required bool condition,
    required Widget widgetFirst,
    required Widget widgetSecond}) {
  return condition ? widgetFirst : widgetSecond;
}

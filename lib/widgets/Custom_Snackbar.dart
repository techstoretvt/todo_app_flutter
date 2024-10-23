import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void customSnackbar({
  required BuildContext context,
  String message = "Message",
  String title = 'Title',
  Duration duration = const Duration(seconds: 3),
  ContentType contentType = ContentType.help,
}) {
  var snackBar = SnackBar(
    elevation: 0,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

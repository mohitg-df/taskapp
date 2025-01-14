import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/typography.dart';
import 'package:taskapp/utils/theme_provider.dart';
import 'package:toastification/toastification.dart';

class Toast {
  Color bgColor = const Color(0xffFFFFFF);

  // success
  toastMessage(context, msg) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: Text('$msg', style: TextStyle(color: themeProvider.isDarkMode ? priText : secText),),
      autoCloseDuration: const Duration(seconds: 5),
      style: ToastificationStyle.simple,
      alignment: Alignment.bottomCenter,
      backgroundColor: bgColor,
      showProgressBar: false,
    );
  }
}
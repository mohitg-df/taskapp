import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/typography.dart';
import 'package:taskapp/utils/theme_provider.dart';

class Loader {

  // build two arc rotating loader
  Widget buildTwoRotatingArc(context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? priText : priBg,
      body: Center(
        child: Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode ? priBg : pri,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: LoadingAnimationWidget.twoRotatingArc(
              color: themeProvider.isDarkMode ? pri : priBg,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }


}
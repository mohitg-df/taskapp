import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:taskapp/typography.dart';

class TextWidget extends StatelessWidget {

  final String? text;
  final double? fontsize;
  final FontWeight? fontWeight;
  final double? letterspacing;
  final Color? color;
  final int? maxline;
  final TextOverflow? oflow;
  final bool? softwrap;
  final TextDecoration? textDecoration;
  final Color? decorationColor;

  const TextWidget({
    super.key,
    required this.text,
    this.fontsize,
    this.fontWeight,
    this.letterspacing,
    this.color,
    this.maxline,
    this.oflow,
    this.softwrap,
    this.textDecoration,
    this.decorationColor,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      "$text",
      overflow: oflow ?? TextOverflow.ellipsis,
      maxLines: maxline , //?? 1
      style: TextStyle(
        decoration: textDecoration,
        decorationColor: decorationColor,
        fontSize: fontsize,
        fontWeight: fontWeight ?? normal,
        letterSpacing: letterspacing,
        color: color ?? priText,
      ),
    );
  }
}
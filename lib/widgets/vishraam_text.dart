import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/verse.dart';

class VishraamText extends StatelessWidget {
  final String text;
  final List<Vishraam> vishraams;
  final double fontSize;
  final String fontFamily;
  final TextAlign textAlign;

  const VishraamText({
    super.key,
    required this.text,
    required this.vishraams,
    required this.fontSize,
    required this.fontFamily,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    if (vishraams.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          height: 1.8,
        ),
        textAlign: textAlign,
      );
    }

    final words = text.split(' ');
    final vishraamMap = <int, String>{
      for (final v in vishraams) v.position: v.type,
    };

    final spans = <InlineSpan>[];
    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      final vishraamType = vishraamMap[i];

      if (vishraamType != null) {
        final color = vishraamType == AppConstants.vishraamLong
            ? const Color(0xFFFF8C00)
            : const Color(0xFF4CAF50);
        spans.add(
          TextSpan(
            text: i < words.length - 1 ? '$word ' : word,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily,
              height: 1.8,
              decoration: TextDecoration.underline,
              decorationColor: color,
              decorationThickness: 2.5,
              color: color,
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: i < words.length - 1 ? '$word ' : word,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: fontFamily,
              height: 1.8,
            ),
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(children: spans),
      textAlign: textAlign,
    );
  }
}

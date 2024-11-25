import 'package:flutter/material.dart';

class Constants {
  static Color primaryColor = const Color(0xff149d9d);
}

class SharedPrefConst{
  static List<String> playSoundOnSilent = [
    "playSoundOnSilentFajr",
    "playSoundOnSilentDhuhr",
    "playSoundOnSilentAsr",
    "playSoundOnSilentMaghrib",
    "playSoundOnSilentIsha",
  ];
  static List<String> isFullAzan = [
    "isFullAzanFajr",
    "isFullAzanDhuhr",
    "isFullAzanAsr",
    "isFullAzanMaghrib",
    "isFullAzanIsha",
  ];
}

///
class FittedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final BoxConstraints boxConstraints;

  const FittedText({super.key,
    required this.text,
    required this.textStyle,
    required this.boxConstraints,
  });

  @override
  Widget build(BuildContext context) {
    // Measure the text size using TextPainter
    final textSpan = TextSpan(text: text, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    // Check if text width or height exceeds the box constraints
    final isTextOverflowing = textPainter.width > boxConstraints.maxWidth ||
        textPainter.height > boxConstraints.maxHeight;

    // If text is overflowing, use FittedBox to scale down
    if (isTextOverflowing) {
      return SizedBox(
        width: boxConstraints.maxWidth,
        height: boxConstraints.maxHeight,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(text, style: textStyle),
        ),
      );
    } else {
      // If text is not overflowing, return it with its natural size
      return Text(text, style: textStyle);
    }
  }
}

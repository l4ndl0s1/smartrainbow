import 'package:flutter/material.dart';

class GradientSliderTrackShape extends RoundedRectSliderTrackShape {
  final Gradient gradient;

  GradientSliderTrackShape({required this.gradient});

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = true,
    double additionalActiveTrackHeight = 0,
    required TextDirection textDirection,
    Offset? secondaryOffset,
  }) {
    
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      thumbCenter: thumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
      textDirection: textDirection,
      secondaryOffset: secondaryOffset,
    );

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Rect activeTrackRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    context.canvas.drawRect(
      activeTrackRect,
      Paint()..shader = gradient.createShader(activeTrackRect),
    );
  }
}

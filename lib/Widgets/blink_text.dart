import 'package:flutter/material.dart';

class ColorCycleTextAnimation extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration duration;

  const ColorCycleTextAnimation({
    Key? key,
    required this.text,
    required this.textStyle,
    required this.duration,
  }) : super(key: key);

  @override
  ColorCycleTextAnimationState createState() => ColorCycleTextAnimationState();
}

class ColorCycleTextAnimationState extends State<ColorCycleTextAnimation> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  final List<Color> _colors = [
    const Color.fromARGB(255, 255, 123, 127),
    const Color.fromARGB(255, 255, 210, 127),
    const Color.fromARGB(255, 255, 255, 125),
    const Color.fromARGB(255, 126, 255, 126),
    const Color.fromARGB(255, 127, 255, 254),
    const Color.fromARGB(255, 119, 150, 255),
    const Color.fromARGB(255, 183, 145, 255),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        // Determine the text color based on the controller's value
        final int index = (_controller!.value * _colors.length).floor() % _colors.length;
        return Text(
          widget.text,
          style: widget.textStyle.copyWith(color: _colors[index]),
        );
      },
    );
  }
}
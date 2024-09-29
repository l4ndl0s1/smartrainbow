import 'package:flutter/material.dart';

class CustomPage extends StatelessWidget {
  final String pageTitle;
  final Color pageColor;
  final List<TextSpan> richTextSpans;

  const CustomPage({
    Key? key,
    required this.pageTitle,
    required this.pageColor,
    required this.richTextSpans, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: pageColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 24, color: Colors.black), 
            children: richTextSpans,
          ),
        ),
      ),
    );
  }
}

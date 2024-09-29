import 'package:flutter/material.dart';

class TemperatureDifferenceDisplay extends StatelessWidget {
  final double difference;
  final String message;
  final Color textColor; // Assuming you've added this to control the text color dynamically

  const TemperatureDifferenceDisplay({
    Key? key,
    required this.difference,
    required this.message,
    this.textColor = Colors.black, // Default color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The builder method constructs a widget that displays both the message and the difference.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 10), // Adding some space between the message and the difference (optional
        Text(
          '${difference.abs().toStringAsFixed(1)}°C', // Displaying the difference as a string here
          style: TextStyle(fontSize: 40, color: textColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

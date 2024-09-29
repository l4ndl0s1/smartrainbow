import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartrainbow/style.dart';

class CurrentTemperatureDisplay extends StatelessWidget {
  final String currentData;

  const CurrentTemperatureDisplay({Key? key, required this.currentData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDisplay = '';
    try {
      // Remove the prefix "CURRENT AVERAGE DAYTIME TEMPERATURE = " if present
      final String dataWithoutPrefix = currentData.contains('=') 
        ? currentData.split('=')[1].trim() 
        : currentData.trim();

      // Split the remaining string by the colon to separate date and temperature
      final parts = dataWithoutPrefix.split(':');
      if (parts.length != 2) {
        throw const FormatException('Invalid data format');
      }

      String datePart = parts[0].trim();
      String temperaturePart = parts[1].trim();

      // Parse and reformat the date
      DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(datePart);
      String reformattedDate = DateFormat('dd.MM.yyyy').format(parsedDate);

      // Construct the display string
      formattedDisplay = 'CURRENT AVERAGE DAYTIME TEMPERATURE: $reformattedDate = $temperaturePart';
    } catch (e) {
      // Handle any errors
      formattedDisplay = 'Error displaying data: $e';
    }

    return Text(
      formattedDisplay,
      style: TextStyle(fontSize: 20, color: formattedDisplay.startsWith('Error') ? Colors.red : AppColors.purple),
    );
  }
}

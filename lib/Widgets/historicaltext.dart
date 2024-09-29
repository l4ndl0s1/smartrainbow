import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartrainbow/style.dart';

class HistoricalTemperatureDisplay extends StatelessWidget {
  final String historicalData;
  const HistoricalTemperatureDisplay({Key? key, required this.historicalData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
  String datePart = historicalData.split(', ')[0].split(': ')[1];
    String temperaturePart = historicalData.split(', ')[1].split(': ')[1];

    // Reformatting the date to use dots (.) instead of dashes (-)
    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(datePart);
    String reformattedDate = DateFormat('dd.MM.yyyy').format(parsedDate);

    String formattedDisplay = 'HISTORICAL AVERAGE DAYTIME TEMPERATURE: $reformattedDate = $temperaturePart';

    return Text(
      formattedDisplay,
      style: const TextStyle(fontSize: 20, color: AppColors.red),
    );
  }
}

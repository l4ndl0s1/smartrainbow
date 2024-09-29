import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:smartrainbow/Services/temp_model.dart';
import 'package:smartrainbow/style.dart';



class CustomLineChartWidget extends StatelessWidget {
  final List<TemperatureComparison> temperatureComparisons;

  const CustomLineChartWidget({Key? key, required this.temperatureComparisons})
      : super(key: key);

 @override
Widget build(BuildContext context) {
  if (temperatureComparisons.isEmpty) {
    return const Center(child: Text("No data available"));
  }

  final minY = temperatureComparisons
        .expand((comparison) => [comparison.historicalTemperature, comparison.currentTemperature])
        .reduce(min)
        .floorToDouble() - 5;
    final maxY = temperatureComparisons
        .expand((comparison) => [comparison.historicalTemperature, comparison.currentTemperature])
        .reduce(max)
        .ceilToDouble() + 5;

    final tempInterval = calculateTemperatureLabelInterval(minY, maxY);


     return LineChart(
      LineChartData(
        
        minY: minY,
        maxY: maxY,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
getTitlesWidget: (value, meta) {
  final index = value.toInt();
  final interval = calculateLabelInterval(temperatureComparisons.length);

  if (index < 0 || index >= temperatureComparisons.length) {
    return const Text(''); 
  }
  if (index == temperatureComparisons.length - 1 || index % interval == 0) {
    final date = temperatureComparisons[index].historicalDate;
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(DateFormat('MM.dd.yyyy').format(date), style: const TextStyle(color: Colors.black, fontSize: 10)),
    );
  }
  return const Text('');
},

            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}°C', style: const TextStyle(color: Colors.black, fontSize: 10)),
              interval: tempInterval, // Use calculated interval
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
        // Historical Temperature Data
        LineChartBarData(
          spots: temperatureComparisons.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.historicalTemperature)).toList(),
          isCurved: true,
          color: AppColors.red, // Adjust color if necessary
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
        // Current Temperature Data
        LineChartBarData(
          spots: temperatureComparisons.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.currentTemperature)).toList(),
          isCurved: true,
          color: AppColors.purple, // Adjust color if necessary
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
      ],
    ),
  );
}

int calculateLabelInterval(int length) {
  if (length <= 8) {
    return 1;
  }

  int desiredLabelsCount = 8;
  int interval = max(1, (length / (desiredLabelsCount - 1)).ceil());

  return interval;
}

double calculateTemperatureLabelInterval(double minTemp, double maxTemp) {

    double range = maxTemp - minTemp;
    return range / 6; 
  }
    }
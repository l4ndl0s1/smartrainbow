import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TemperatureComparison(),
    );
  }
}

class TemperatureComparison extends StatefulWidget {
  const TemperatureComparison({super.key});

  @override
  TemperatureComparisonState createState() => TemperatureComparisonState();
}

class TemperatureComparisonState extends State<TemperatureComparison>
    with SingleTickerProviderStateMixin {
  String historicalData = '';
  String currentData = '';
  String temperatureDifference = '';
  DateTime selectedDate = DateTime.now();
  DateTime startDate = DateTime(1855);
  DateTime endDate = DateTime.now();
  Timer? _debounce;
  double sliderValue = DateTime.now().year.toDouble();
  int startYear = 1855;
  int currentYear = DateTime.now().year;
  late Map<int, String> yearLabels = getYearLabels();
  AnimationController? _animationController;
  String temperatureMessage = '';

  Future<void> fetchHistoricalData(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String historicalEndpoint =
        'https://dataset.api.hub.geosphere.at/v1/station/historical/klima-v1-1d?parameters=t&start=$formattedDate&end=$formattedDate&station_ids=105&output_format=geojson';
    final response = await http.get(Uri.parse(historicalEndpoint));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final timestamps = List<String>.from(data['timestamps']);
      final features = List<Map>.from(data['features']);

      if (features.isNotEmpty && timestamps.isNotEmpty) {
        final feature = features.first;
        final properties = feature['properties'];

        if (properties != null && properties.containsKey('parameters')) {
          final parameters = properties['parameters'];
          final parameterKey = parameters.keys.first;

          if (parameters[parameterKey] != null &&
              parameters[parameterKey].containsKey('data')) {
            final temperatureData = parameters[parameterKey]['data'];
            final temperature =
                temperatureData.isNotEmpty ? temperatureData[0] : 'N/A';
            final date = timestamps.first;

            setState(() {
              historicalData = 'Date: $date, Temperature: $temperature';
            });
          }
        }
      }
    } else {
      throw Exception('Failed to load historical data');
    }
  }

  Future<void> fetchCurrentData() async {
    const String currentEndpoint =
        'https://dataset.api.hub.geosphere.at/v1/station/current/tawes-v1-10min?parameters=TL&station_ids=11035';
    final response = await http.get(Uri.parse(currentEndpoint));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final timestamps = List<String>.from(data['timestamps']);
      final features = List<Map>.from(data['features']);

      if (features.isNotEmpty && timestamps.isNotEmpty) {
        final feature = features.first;
        final properties = feature['properties'];

        if (properties != null && properties.containsKey('parameters')) {
          final parameters = properties['parameters'];
          final parameterKey = parameters.keys.first;

          if (parameters[parameterKey] != null &&
              parameters[parameterKey].containsKey('data')) {
            final temperatureData = parameters[parameterKey]['data'];
            final temperature =
                temperatureData.isNotEmpty ? temperatureData[0] : 'N/A';
            final date = timestamps.first;

            setState(() {
              currentData = 'Date: $date, Temperature: $temperature';
            });
          }
        }
      }
    } else {
      throw Exception('Failed to load current data');
    }
  }

  void calculateTemperatureDifference() {
    if (historicalData.isNotEmpty && currentData.isNotEmpty) {
      final historicalTemp = double.tryParse(
              historicalData.split(',').last.split(':').last.trim()) ??
          0.0;
      final currentTemp =
          double.tryParse(currentData.split(',').last.split(':').last.trim()) ??
              0.0;

      final difference = currentTemp - historicalTemp;
      setState(() {
        temperatureDifference = difference.toStringAsFixed(2);

        if (difference < 0) {
          _animationController?.stop();
          temperatureMessage =
              'Temperature is lower than historical data. (STOPPED!)';
        } else {
          if (_animationController != null) {
            _animationController!.duration =
                Duration(seconds: max(1, (10 - difference.abs()).toInt()));
            _animationController!.repeat();
          }
          temperatureMessage =
              'Temperature is higher than historical data. (SPINNING!)';
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    fetchHistoricalData(DateTime.now())
        .then((_) => calculateTemperatureDifference());
    fetchCurrentData().then((_) => calculateTemperatureDifference());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  void onSliderChanged(double value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      updateDateFromSlider(value);
    });
  }

  void updateDateFromSlider(double value) {
    setState(() {
      sliderValue = value;
      int selectedYear = value.toInt();
      DateTime currentDate = DateTime.now();
      selectedDate = DateTime(selectedYear, currentDate.month, currentDate.day);
    });
    fetchHistoricalData(selectedDate)
        .then((_) => calculateTemperatureDifference());
  }

  Map<int, String> getYearLabels() {
    Map<int, String> labels = {};
    for (int year = startYear; year <= currentYear; year++) {
      int division = year - startYear;
      labels[division] = year.toString();
    }
    return labels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Smart Rainbow 7.0 Test UI',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController!,
                child: Image.asset('assets/spin.png', fit: BoxFit.cover),
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animationController!.value *
                        2 *
                        3.14159, // Full rotation
                    child: child,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Hohe Warte, Vienna, Austria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Historical: $historicalData °C',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              'Current: $currentData °C',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            if (temperatureDifference.isNotEmpty)
              Text(
                'Difference: $temperatureDifference °C',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            Text(temperatureMessage,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Slider(
                autofocus: true,
                min: startYear.toDouble(),
                max: currentYear.toDouble(),
                divisions: currentYear - startYear,
                value: sliderValue,
                onChanged: (value) => onSliderChanged(value),
                label: yearLabels[(sliderValue - startYear).round()],
              ),
            ),
            Text(
              'Selected Year: ${sliderValue.toInt()}',
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

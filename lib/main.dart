// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:smartrainbow/Pages/model3d.dart';


import 'package:smartrainbow/Services/safetemp.dart';

import 'package:smartrainbow/Services/temp_model.dart';
import 'package:smartrainbow/Widgets/blink_text.dart';
import 'package:smartrainbow/Pages/bluethooth_connection_screen.dart';
import 'package:smartrainbow/Widgets/costume_appbar.dart';
import 'package:smartrainbow/Widgets/costume_year_picker.dart';
import 'package:smartrainbow/Widgets/currenttext.dart';

import 'package:smartrainbow/Widgets/historicaltext.dart';
import 'package:smartrainbow/Widgets/loading_rainbow.dart';
import 'package:smartrainbow/Widgets/rainbow_buttons.dart';
import 'package:smartrainbow/Widgets/slider.dart';
import 'package:smartrainbow/line.dart';
import 'package:smartrainbow/style.dart';

import 'Pages/video_player.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Helvetica',
      ),
      debugShowCheckedModeBanner: false,
      home: const BluetoothTemperatureApp(),
    );
  }
}

class BluetoothTemperatureApp extends StatefulWidget {
  const BluetoothTemperatureApp({super.key});

  @override
  BluetoothTemperatureAppState createState() => BluetoothTemperatureAppState();
}

class BluetoothTemperatureAppState extends State<BluetoothTemperatureApp>
    with SingleTickerProviderStateMixin {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  BluetoothConnection? _connection;
       bool _isDisconnecting = false; 
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _isConnected = false;
  bool _isLoadingTemperatureData = false;
  String historicalTemperature = "Loading...";
  String historicalData = 'Awaiting historical data...';
  String currentData = 'Awaiting current data...';
  String temperatureDifference = 'Calculating...';
  DateTime selectedDate = DateTime.now();
  String temperatureMessage = 'Awaiting temperature data...';
  final int baseSpeed = 100;
  final double multiplier = 1.0;
  DateTime startDate = DateTime(1855);
  DateTime endDate = DateTime.now();
String rotationSpeed = "30deg";
  double sliderValue = DateTime.now().year.toDouble();
  int startYear = 1855;
  int currentYear = DateTime.now().year;
  Color messageColor = Colors.black;
  double difference = 0.0;
  AnimationController? _animationController;
  AnimationController? _animationController1;
  Timer? _debounceTimer;
  List<TemperatureComparison> temperatureComparisons = [];
 final int baseRotationSpeedDeg = 100; 
 String tempDifferenceStr = 'Calculating...'; 


  @override
  void initState() {
    _animationController1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _animationController1?.addListener(() => setState(() {}));
    _animationController1?.repeat();
    super.initState();
    _loadTemperatureComparisons();
    selectedDate = _adjustToYesterdayIfNeeded(DateTime.now());
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;

        _animationController = AnimationController(
          duration: const Duration(seconds: 5),
          vsync: this,
        )..repeat();
      });
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        getBondedDevices();
      });
    });

    getBondedDevices();
    _calculateAndDisplayTemperatureData();
  }

  void getBondedDevices() async {
    try {
      List<BluetoothDevice> bondedDevices =
          await FlutterBluetoothSerial.instance.getBondedDevices();
      setState(() {
        _devicesList = bondedDevices;
      });
    } catch (e) {
      print('Error getting bonded devices: $e');
    }
  }

  Future<void> _loadTemperatureComparisons() async {
    final prefsService = PreferencesService();
    List<TemperatureComparison> comparisons =
        await prefsService.getTemperatureComparisons();
    print("Loaded ${comparisons.length} comparisons");
    setState(() {
      temperatureComparisons = comparisons;
    });
  }

  Future<void> _calculateAndDisplayTemperatureData() async {

    setState(() {
      _isLoadingTemperatureData = true; 
    });

    try {
      await Future.wait([
        fetchHistoricalData(selectedDate),
        fetchCurrentData(),
      ]);
      calculateTemperatureDifference();
// Example scaling

    } catch (error) {
      print('Error fetching temperature data: $error');
      setState(() {
        temperatureMessage = 'Error fetching temperature data';
      });
    } finally {
      setState(() {
        _isLoadingTemperatureData = false;
      });
    }
  }
Future<String> calculateRotationSpeed() async {

  double rotationSpeedDegPerDegreeDiff = 10.0; 


  double newRotationSpeedDeg = difference * rotationSpeedDegPerDegreeDiff;


  if (newRotationSpeedDeg < 0) newRotationSpeedDeg = -newRotationSpeedDeg; 
  if (difference == 0.0) newRotationSpeedDeg = 0; 

  String calculatedRotationSpeed = "${newRotationSpeedDeg.toStringAsFixed(2)}deg";




  return calculatedRotationSpeed;
}


  Future<void> fetchHistoricalData(DateTime date) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime queryDate = date;

    if (date.compareTo(today) >= 0) {
      queryDate = today.subtract(const Duration(days: 1));
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(queryDate);
    String historicalEndpoint =
    'https://dataset.api.hub.geosphere.at/v1/station/historical/klima-v2-1d?parameters=tl_mittel&start=$formattedDate&end=$formattedDate&station_ids=105&output_format=geojson';
final response = await http.get(Uri.parse(historicalEndpoint));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = List<Map>.from(data['features']);

      if (features.isNotEmpty) {
        final feature = features.first;
        final properties = feature['properties'];

        if (properties != null && properties.containsKey('parameters')) {
          final parameters = properties['parameters'];
          final parameterKey = parameters.keys.first;

          if (parameters[parameterKey] != null &&
              parameters[parameterKey].containsKey('data')) {
            final temperatureData = parameters[parameterKey]['data'];
            final temperature = temperatureData.isNotEmpty
                ? "${temperatureData[0]}°C"
                : 'No Data Available';

            setState(() {
     
              historicalTemperature = temperature;
        
              historicalData =
                  'Date: ${DateFormat('dd-MM-yyyy').format(queryDate)}, Temperature: $temperature';
            });
          }
        }
      }
    } else {
      print('Failed to load historical data');
    }
  }

  Future<void> fetchCurrentData() async {
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);
    String formattedDate = DateFormat('yyyy-MM-dd').format(yesterday);
    DateFormat('dd.MM.yyyy').format(yesterday);
    String endpoint =
        'https://dataset.api.hub.geosphere.at/v1/station/historical/klima-v2-1d?parameters=tl_mittel&start=$formattedDate&end=$formattedDate&station_ids=105&output_format=geojson';

    final response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = List<Map>.from(data['features']);

      if (features.isNotEmpty) {
        final feature = features.first;
        final properties = feature['properties'];

        if (properties != null && properties.containsKey('parameters')) {
          final parameters = properties['parameters'];
          final parameterKey = parameters.keys.first;

          if (parameters[parameterKey] != null &&
              parameters[parameterKey].containsKey('data')) {
            final temperatureData = parameters[parameterKey]['data'];
            final temperature = temperatureData.isNotEmpty
                ? "${temperatureData[0]}°C"
                : 'No Data Available';

            setState(() {
              currentData =
                  'CURRENT AVERAGE DAYTIME TEMPERATURE =  $formattedDate: $temperature';
            });
          }
        }
      }
    }
  }

  void calculateTemperatureDifference() {
    if (historicalData.isNotEmpty && currentData.isNotEmpty) {
 
      final historicalTemp = double.tryParse(historicalData
              .split(',')
              .last
              .split(':')
              .last
              .trim()
              .replaceAll('°C', '')) ??
          0.0;
      final currentTemp = double.tryParse(currentData
              .split(',')
              .last
              .split(':')
              .last
              .trim()
              .replaceAll('°C', '')) ??
          0.0;

      difference = currentTemp - historicalTemp;

      setState(() {
        temperatureDifference = difference.toStringAsFixed(2);
        _sendTemperatureDifference();
         tempDifferenceStr = 'Temperature Difference: $temperatureDifference';
        final prefsService = PreferencesService();
        final comparison = TemperatureComparison(
          historicalDate: selectedDate,
          historicalTemperature: historicalTemp,
          currentTemperature: currentTemp,
          temperatureDifference: difference,
        );

       
        prefsService.saveTemperatureComparison(comparison).then((_) {
          print("Temperature comparison saved successfully.");

          _loadTemperatureComparisons();
        }).catchError((error) {
          print("Failed to save temperature comparison: $error");
        });
 
        if (_animationController != null) {
          var speedMultiplier = 1.0 + difference.abs();
          _animationController!.duration =
              Duration(seconds: (20 / speedMultiplier).round());
          _animationController!.repeat();
          if (difference != 0) {
          } else {
            _animationController!.stop();
          }
        }

        if (difference < 0) {
          temperatureMessage =
              'Temperature is lower than historical data by ${difference.abs().toStringAsFixed(1)}°C.';
          messageColor = AppColors.red;
        } else if (difference > 0) {
          temperatureMessage =
              'Temperature is higher than historical data by ${difference.toStringAsFixed(1)}°C.';
          messageColor = AppColors.purple;
        } else {
          temperatureMessage =
              'Temperature is the same as the historical data.';
          messageColor = AppColors.green;
        }
      });
    }
  }

void _connect(BluetoothDevice? device) async {
        if (device == null) {
            print('Bluetooth device is null');
            return;
        }

        try {
            final connection = await BluetoothConnection.toAddress(device.address);
            print('Connected to the device: ${device.name}');

            setState(() {
                _device = device;
                _connection = connection;
                _isConnected = true;
                _isDisconnecting = false;  // Reset disconnecting flag
            });

            connection.input!.listen((data) {
                print('Data incoming: ${ascii.decode(data)}');
            }).onDone(() {
                if (!_isDisconnecting) {
                    print('Disconnected by remote request, trying to reconnect...');
                    _connect(_device);  // Attempt to reconnect
                } else {
                    print('Disconnected locally');
                }

                setState(() {
                    _isConnected = false;
                    _device = null;
                });
            });
        } catch (e) {
            print('Cannot connect, exception occurred: $e');
            setState(() {
                _isConnected = false;
                _device = null;
            });
        }
    }


  void _sendTemperatureDifference() async {
    if (_connection != null && _connection!.isConnected) {
      // Format the message with the temperature difference
      String messageToSend = "Temperature difference: $temperatureDifference\n";
      print('Sending message: $messageToSend');

      // Convert the string message to UTF-8 encoding and send it over Bluetooth
      _connection!.output.add(utf8.encode(messageToSend));
      await _connection!.output.allSent;
      print('Temperature difference sent: $temperatureDifference');
    } else {
      print('No device connected.');
    }
  }

  void _navigateAndConnectToDevice() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => BluetoothConnectionScreen(
                devicesList: _devicesList,
                onConnect: (device) {
                  Navigator.of(context).pop(); // Close the connection screen
                  _connect(device); // Call your existing connect method
                },
              )),
    );
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void onSliderChanged(double value) {
    // Update the UI immediately for smooth slider feedback
    setState(() {
      sliderValue = value;
      selectedDate =
          DateTime(value.toInt(), selectedDate.month, selectedDate.day);
    });

    // Debounce the data fetching logic
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
      _calculateAndDisplayTemperatureData(); // Fetch data after delay
    });
  }

  void updateDateFromSlider(double value) {
    // Now this function is purely for processing the final slider value
    int selectedYear = value.toInt();
    DateTime selectedDateTime =
        DateTime(selectedYear, DateTime.now().month, DateTime.now().day);

    // You might want to avoid redundant state updates if the selected date hasn't changed
    if (selectedDate.year != selectedYear) {
      setState(() {
        selectedDate = selectedDateTime;
      });
      // Assuming you perform some actions like fetching data based on the selected date
    }

    // Adding a small delay before fetching the data
    Future.delayed(const Duration(milliseconds: 1000), () {
      _calculateAndDisplayTemperatureData();
    });
  }

  Map<int, String> getYearLabels(int startYear, int endYear, int interval) {
    Map<int, String> labels = {};

    for (int year = startYear; year <= endYear; year += interval) {
      labels[year] = year.toString();
    }

    return labels;
  }

  void updateDateAndSliderValue(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      sliderValue = newDate.year.toDouble();
      _calculateAndDisplayTemperatureData();
    });
  }

  void resetToCurrentDate() {
    final DateTime now = DateTime.now();

    final DateTime adjustedDate = _adjustToYesterdayIfNeeded(now);
    setState(() {
      selectedDate = adjustedDate;
      sliderValue = adjustedDate.year.toDouble();
      _calculateAndDisplayTemperatureData();
    });
  }

  void onDateChanged(DateTime newDate) {
    DateTime adjustedDate = _adjustToYesterdayIfNeeded(newDate);
    print("Adjusted Date: $adjustedDate");
    setState(() {
      selectedDate = adjustedDate;
      sliderValue = adjustedDate.year.toDouble();
    });

    _calculateAndDisplayTemperatureData();
    fetchHistoricalData(adjustedDate);
  }

  DateTime _adjustToYesterdayIfNeeded(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (date.compareTo(today) >= 0) {
      return today.subtract(const Duration(days: 1));
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 200, 200, 200),
      appBar: customAppBar(
        onBluetoothPressed: _navigateAndConnectToDevice,
        onResetPressed: resetToCurrentDate,
      ),
      body: Column(
        children: [
          const SizedBox(height: 11),
          
         
          if (_isLoadingTemperatureData)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0)
                        .animate(_animationController1!),
                    child: const GradientCircularProgressIndicator(
                      radius: 100,
                      gradientColors: [
                        Color.fromARGB(255, 255, 123, 127),
                        Color.fromARGB(255, 255, 210, 127),
                        Color.fromARGB(255, 255, 255, 125),
                        Color.fromARGB(255, 126, 255, 126),
                        Color.fromARGB(255, 127, 255, 254),
                        Color.fromARGB(255, 119, 150, 255),
                        Color.fromARGB(255, 183, 145, 255),
                      ],
                      strokeWidth: 10.0,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text('GeoSphere Austria weather data is loading', style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 255, 255, 255),)),
                ],
              ),
            )
          else
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  const Column(
            children: [
              Text('smart rainbow 7.0 - ice sculpture cursor rpm-speed',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold)),
              Text('REMOTE CONTROL',
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold)),
            ],
          ),
                  const SizedBox(height: 15),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      valueIndicatorColor:Colors.transparent,
                         valueIndicatorTextStyle: const TextStyle(
               color: Colors.white, fontSize: 18,
               
                      ),
                      trackHeight: 15.0,
                      inactiveTrackColor: const Color.fromARGB(255, 200, 200, 200),
                      trackShape: GradientSliderTrackShape(
                        
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 255, 123, 127),
                            Color.fromARGB(255, 255, 210, 127),
                            Color.fromARGB(255, 255, 255, 125),
                            Color.fromARGB(255, 126, 255, 126),
                            Color.fromARGB(255, 127, 255, 254),
                            Color.fromARGB(255, 119, 150, 255),
                            Color.fromARGB(255, 183, 145, 255),
                          ],
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('1855',
                            style:
                                TextStyle(fontSize: 17, color: AppColors.red)),
                        Expanded(
                          child: Slider(
                            thumbColor: Colors.white,
                            
                            value: sliderValue,
                            min: 1855,
                            max: 2024,
                            divisions: (2024 - 1855) ~/ 1,
                            
                            label: sliderValue.round().toString(),
                            onChanged: (value) {
                              setState(() {
                                sliderValue = value;
                                selectedDate = DateTime(value.toInt(),
                                    selectedDate.month, selectedDate.day);
                              });

                              onSliderChanged(value);
                            },
                          ),
                        ),
                        const Text('2024',
                            style: TextStyle(
                                fontSize: 17, color: AppColors.purple)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 0),
                  CustomYearPicker(
                    selectedDate: selectedDate,
                    onYearChanged: (newDate) {
                      updateDateAndSliderValue(newDate);
                      setState(() {
                        selectedDate = newDate;
                        _calculateAndDisplayTemperatureData();
                      });
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HistoricalTemperatureDisplay(
                                historicalData: historicalData),
                            const SizedBox(height: 10),
                            CurrentTemperatureDisplay(currentData: currentData),
                            const SizedBox(height: 10),
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'DIFFERENCE OF  ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                  TextSpan(
                                      text: 'HISTORICAL ',
                                      style: TextStyle(
                                          fontSize: 20, color: AppColors.red)),
                                  TextSpan(
                                      text: 'AND ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                  TextSpan(
                                      text: 'CURRENT ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: AppColors.purple)),
                                  TextSpan(
                                      text: 'TEMPERATURE ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ColorCycleTextAnimation(
  duration: const Duration(seconds: 1),
  text: '${difference.toStringAsFixed(1)}°C',  
  textStyle: const TextStyle(
    fontSize: 77,
    fontWeight: FontWeight.normal,
  ),
),

                            const SizedBox(height: 0),
                            GradientText(
                              textAlign: TextAlign.center,
                     'THE HIGHER THE TEMPERATURE DIFFERENCE,\n THE FASTER THE ICE SCULPTURE IS TURNING IN THE FREEZER BOX',
                style: const TextStyle(
                  fontSize: 14,
                ),
                gradientType: GradientType.linear,
                
                colors: const [
                  Color.fromARGB(255, 255, 123, 127),
                            Color.fromARGB(255, 255, 210, 127),
                            Color.fromARGB(255, 255, 255, 125),
                            Color.fromARGB(255, 126, 255, 126),
                            Color.fromARGB(255, 127, 255, 254),
                            Color.fromARGB(255, 119, 150, 255),
                            Color.fromARGB(255, 183, 145, 255),
                ],
              ),
                            
                            const SizedBox(height: 40),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: SizedBox(
                                height: 200,
                                child: CustomLineChartWidget(
                                  temperatureComparisons:
                                      temperatureComparisons,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                          'smart_rainbow 7.0_system errors: 7 (0x7)',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      const Text('TEXTBASED: ',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      const SizedBox(height: 15),
                      RainbowButtons(
                          navigateToPage: (page) =>
                              navigateToPage(context, page)),
                      const SizedBox(height: 30),
                      const Text(
                          '3D MODEL BASED:',
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                      const SizedBox(height: 15),
                      Container(
  
    padding: const EdgeInsets.all(0.1),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(100.0),
    ),
    child:SizedBox(
                        height: 110,
                        child: GestureDetector(
                          
                          onTap: () async {
  
    String calculatedRotationSpeed = await calculateRotationSpeed(); 

    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
       // builder: (context) =>const Video(),
        builder: (context) => My3DModelPage(rotationSpeed: calculatedRotationSpeed,  tempDifference: tempDifferenceStr, ),
      ),
    );
  },
                          child: _animationController != null
                              ? RotationTransition(
                                  turns: _animationController!,
                                  child: Image.asset('assets/3d und last cursor now.png'),
                                )
                              : Image.asset('assets/3d und last cursor now.png'),
                        ),
                      ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  )
                ],
              ),
            ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only( right: 8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: _device != null && _isConnected
                  ? const Text(
                      'smart rainbow 7.0: connected',
                     // '${_device!.name}: connected',
                      style: TextStyle(
                          fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
                    )
                  : const Text(
                      'smart rainbow 7.0: disconnected',
                      style: TextStyle(
                          fontSize: 12, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
     _isDisconnecting = true;  // Set disconnecting flag
    _connection?.dispose();
    _animationController?.dispose();
    super.dispose();
  }
}

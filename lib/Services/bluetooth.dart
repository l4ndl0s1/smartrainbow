// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService {
  BluetoothConnection? _connection;
  final StreamController<BluetoothDevice> _deviceController = StreamController.broadcast();
  final StreamController<String> _dataController = StreamController.broadcast();

  Stream<BluetoothDevice> get deviceStream => _deviceController.stream;
  Stream<String> get dataStream => _dataController.stream;

  Future<void> initialize() async {
    // Initialize Bluetooth
    final List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    for (var device in devices) {
      _deviceController.add(device);
    }
  }

  Future<void> connectToDevice(String address) async {
    try {
      _connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');

      _connection!.input!.listen((Uint8List data) {
        _dataController.add(utf8.decode(data));
      }).onDone(() {
        // Handle connection closure
      });
    } catch (e) {
      print('Cannot connect, exception occurred');
      print(e);
    }
  }

  Future<void> sendData(String data) async {
    if (_connection != null && _connection!.isConnected) {
      _connection!.output.add(utf8.encode("$data\n"));
      await _connection!.output.allSent;
      print('Data sent');
    } else {
      print('No device connected');
    }
  }

  void disconnect() {
    _connection?.dispose();
    _connection = null;
    print('Disconnected from the device');
  }

  void dispose() {
    _deviceController.close();
    _dataController.close();
    disconnect();
  }
}

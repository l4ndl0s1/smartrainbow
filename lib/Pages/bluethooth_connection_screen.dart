// BluetoothConnectionScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothConnectionScreen extends StatefulWidget {
  final List<BluetoothDevice> devicesList;
  final Function(BluetoothDevice) onConnect;

  const BluetoothConnectionScreen({
    Key? key,
    required this.devicesList,
    required this.onConnect,
  }) : super(key: key);

  @override
  State<BluetoothConnectionScreen> createState() => _BluetoothConnectionScreenState();
}

class _BluetoothConnectionScreenState extends State<BluetoothConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Device'),
        
      ),
      body: ListView.builder(
        itemCount: widget.devicesList.length,
        itemBuilder: (context, index) {
          BluetoothDevice device = widget.devicesList[index];
          return ListTile(
            title: Text(device.name ?? "Unknown Device"),
            subtitle: Text(device.address),
            onTap: () => widget.onConnect(device),
          );
        },
      ),
    );
  }
}

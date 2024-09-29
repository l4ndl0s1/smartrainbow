import 'package:flutter/material.dart';
import 'package:smartrainbow/style.dart';
// Ensure the correct file name

// Assuming this method is within a StatelessWidget or StatefulWidget class
AppBar customAppBar({
  required VoidCallback onBluetoothPressed,
  required VoidCallback onResetPressed,
}) {
  return AppBar(
    centerTitle: true,
    toolbarHeight: 120.0, // Adjust this value to fit your content
     backgroundColor: const Color.fromARGB(255, 215, 215, 215),
    title: SizedBox(
      // Providing explicit height for the title container can help manage layout
      height: 110.0, // Make sure this fits within the toolbarHeight
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: ' SMART  ' , style: TextStyle(fontSize: 30, color: AppColors.red)),
                TextSpan(text: 'RAINBOW  ', style: TextStyle(fontSize: 30, color: AppColors.orange)),
                TextSpan(text: '7.  ', style: TextStyle(fontSize: 30, color: AppColors.yellow)),
                TextSpan(text: '0  ', style: TextStyle(fontSize: 30, color: AppColors.green)),
                TextSpan(text: 'CLIMATE  ', style: TextStyle(fontSize: 30, color: AppColors.cyan)),
                TextSpan(text: 'CHANGE ', style: TextStyle(fontSize: 30, color: AppColors.blue)),
              ],
            ),
          ),
          // This TextSpan is for your specific long text that needs more space
          const Text(
            'M    O      N      I     T     O      R     I     N     G',
            style: TextStyle(fontSize: 30, color: AppColors.purple),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    actions: <Widget>[
      IconButton(
        iconSize: 27.0, 
        icon: const Icon(Icons.bluetooth,color: AppColors.purple,),
        onPressed: onBluetoothPressed,
        tooltip: 'Connect to a Bluetooth device',
      ),
    ],
    leading: IconButton(
           iconSize: 27.0, 
      icon: const Icon(Icons.refresh,color: AppColors.red,),
      onPressed: onResetPressed,
      tooltip: 'Reset to current date',
    ),
  );
}
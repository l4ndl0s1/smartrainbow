import 'package:flutter/material.dart';
import 'package:smartrainbow/Widgets/layout_backgroundimage';
import 'package:smartrainbow/style.dart';

class BPage extends StatelessWidget {
  const BPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
 
    return const FullImage(
      pageTitle: '',
      pageColor: Colors.transparent,
      backColor: AppColors.cyan ,
      backgroundImageUrl:'assets/text/5_cyane flugticket.png', 
   
    );
  }
}


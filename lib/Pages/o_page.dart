import 'package:flutter/material.dart';
import 'package:smartrainbow/Widgets/layout_backgroundimage';
import 'package:smartrainbow/style.dart';

class OPage extends StatelessWidget {
  const OPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return const FullImage(
      pageTitle: '',
      pageColor: Colors.transparent,
      backColor: AppColors.blue ,
      backgroundImageUrl:'assets/text/6_blaue ente.png', 
   
    );
  }
}

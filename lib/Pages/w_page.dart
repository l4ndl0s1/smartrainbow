import 'package:flutter/material.dart';
import 'package:smartrainbow/Widgets/layout_backgroundimage';
import 'package:smartrainbow/style.dart';

class WPage extends StatelessWidget {
  const WPage({Key? key}) : super(key: key);

    @override
  Widget build(BuildContext context) {
 
    return const FullImage(
      pageTitle: '',
      pageColor: Colors.transparent,
      backColor: AppColors.purple ,
      backgroundImageUrl:'assets/text/7_violeter qr-code.png', 
   
    );
  }
}


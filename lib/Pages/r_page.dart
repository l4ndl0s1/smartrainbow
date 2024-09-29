import 'package:flutter/material.dart';
import 'package:smartrainbow/Widgets/layout_backgroundimage';
import 'package:smartrainbow/style.dart';


class RPage extends StatelessWidget {
  const RPage({super.key});

  @override
  Widget build(BuildContext context) {
 
    return const FullImage(
      pageTitle: '',
      pageColor: Colors.transparent,
      backColor: AppColors.red ,
      backgroundImageUrl:'assets/text/1_roter text.png', 
   
    );
  }
}

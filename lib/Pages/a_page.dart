import 'package:flutter/material.dart';
import 'package:smartrainbow/Widgets/layout_backgroundimage';
import 'package:smartrainbow/style.dart';

class APage extends StatelessWidget {
  const APage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
 
    return const FullImage(
      pageTitle: '',
      pageColor: Colors.transparent,
      backColor: AppColors.orange ,
      backgroundImageUrl:'assets/text/2_orange kohle.png', 
   
    );
  }
}

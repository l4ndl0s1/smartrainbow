import 'package:flutter/material.dart';
import 'package:smartrainbow/Widgets/layout_backgroundimage';
import 'package:smartrainbow/style.dart';

class NPage extends StatelessWidget {
  const NPage({Key? key}) : super(key: key);

    @override
  Widget build(BuildContext context) {
 
    return const FullImage(
      pageTitle: '',
      pageColor: Colors.transparent,
      backColor: AppColors.green ,
      backgroundImageUrl:'assets/text/4_grunes glysophat.png', 
   
    );
  }
}


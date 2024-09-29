import 'package:flutter/material.dart';
import 'package:smartrainbow/Widgets/layout_backgroundimage';
import 'package:smartrainbow/style.dart';

class IPage extends StatelessWidget {
  const IPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return const FullImage(
      pageTitle: '',
      pageColor: Colors.transparent,
      backColor: AppColors.yellow ,
      backgroundImageUrl:'assets/text/3_gelbe AtomEdose.png', 
   
    );
  }
}


import 'package:flutter/material.dart';
import 'package:smartrainbow/Pages/a_page.dart';
import 'package:smartrainbow/Pages/b_page.dart';
import 'package:smartrainbow/Pages/i_page.dart';
import 'package:smartrainbow/Pages/n_page.dart';
import 'package:smartrainbow/Pages/o_page.dart';
import 'package:smartrainbow/Pages/r_page.dart';
import 'package:smartrainbow/Pages/w_page.dart';
import 'package:smartrainbow/style.dart';



class RainbowButtons extends StatelessWidget {
  final Function navigateToPage;

  const RainbowButtons({super.key, required this.navigateToPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          style: ButtonStyle(
             
              elevation: MaterialStateProperty.all(10.0),
             overlayColor: MaterialStateProperty.all(AppColors.red),
                 side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromARGB(100, 255, 255, 255), width: 2.0)),
              ),
             
          child: const Text(
            "R",
            style: TextStyle(color: AppColors.red, fontSize: 30),
            
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RPage()),
          ),
        ),
        TextButton(
           style: ButtonStyle(
             
              elevation: MaterialStateProperty.all(10.0),
             overlayColor: MaterialStateProperty.all(AppColors.orange),
                 side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromARGB(100, 255, 255, 255), width: 2.0)),
              ),
          child: const Text("A",
              style: TextStyle(color: AppColors.orange, fontSize: 30),
              ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const APage()),
          ),
        ),
        TextButton(
           style: ButtonStyle(
             overlayColor: MaterialStateProperty.all(AppColors.yellow),
              elevation: MaterialStateProperty.all(10.0),
             
                 side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromARGB(100, 255, 255, 255), width: 2.0)),
              ),
          child: const Text("I",
              style: TextStyle(color: AppColors.yellow, fontSize: 30)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IPage()),
          ),
        ),
        TextButton(
           style: ButtonStyle(
             
              elevation: MaterialStateProperty.all(10.0),
             overlayColor: MaterialStateProperty.all(AppColors.green),
                 side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromARGB(100, 255, 255, 255), width: 2.0)),
              ),
          child: const Text("N",
              style: TextStyle(color: AppColors.green, fontSize: 30)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NPage()),
          ),
        ),
        TextButton(
           style: ButtonStyle(
             overlayColor: MaterialStateProperty.all(AppColors.cyan),
              elevation: MaterialStateProperty.all(10.0),
             
                 side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromARGB(100, 255, 255, 255), width: 2.0)),
              ),
          child: const Text("B",
              style: TextStyle(color: AppColors.cyan, fontSize: 30)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BPage()),
          ),
        ),
        TextButton(
           style: ButtonStyle(
             overlayColor: MaterialStateProperty.all(AppColors.blue),
              elevation: MaterialStateProperty.all(10.0),
             
                 side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromARGB(100, 255, 255, 255), width: 2.0)),
              ),
          child: const Text("O",
              style: TextStyle(color: AppColors.blue, fontSize: 30)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OPage()),
          ),
        ),
        TextButton(
           style: ButtonStyle(
             
              elevation: MaterialStateProperty.all(10.0),
             overlayColor: MaterialStateProperty.all(AppColors.purple),
                 side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromARGB(100, 255, 255, 255), width: 2.0)),
              ),
          child: const Text("W",
              style: TextStyle(color: AppColors.purple, fontSize: 30)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WPage()),
          ),
        ),
      ],
    );
  }
}

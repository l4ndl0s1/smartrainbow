import 'package:flutter/material.dart';
import 'package:smartrainbow/style.dart';


class CustomYearPicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onYearChanged;

  const CustomYearPicker({
    Key? key,
    required this.selectedDate,
    required this.onYearChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          SizedBox(
            height: 40,
            width: 100,
            
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 200, 200, 200)),
                elevation:MaterialStateProperty.all(0),
                side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromARGB(200, 255, 255, 255), width: 2.0)),
                
             
              ),
              onPressed: () => _showYearPickerDialog(context),
              child: const Text(
                'SELECT\nYEARS' ,
                style: TextStyle(
                  letterSpacing: 1,
                  height: 1.1,
          
                  fontSize: 12,
                  color: AppColors.red),
                ),
              ),
            ),
        
        ],
      ),
    );
  }

 void _showYearPickerDialog(BuildContext context) async {
  final int currentYear = DateTime.now().year;
  const int startYear = 1855;
  final int endYear = currentYear;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      final Size screenSize = MediaQuery.of(context).size;
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 400,
          width: screenSize.width * 0.1,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 125),
                Color.fromARGB(255, 126, 255, 126),
                Color.fromARGB(255, 127, 255, 254),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          child: ListView.builder(
            itemCount: endYear - startYear + 1,
            itemBuilder: (BuildContext context, int index) {
              int year = startYear + index;
              return InkWell(
                onTap: () {
                  onYearChanged(DateTime(
                    year,
                    selectedDate.month,
                    selectedDate.day,
                  ));
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50, 
                  child: Text(
                    year.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17, 
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
}
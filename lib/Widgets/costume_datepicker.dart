import 'package:flutter/material.dart';
import 'package:smartrainbow/style.dart';


class CustomDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final String historicalTemperature; // Add this

  const CustomDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.historicalTemperature, // Add this
  }) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.selectedDate.day;
    selectedMonth = widget.selectedDate.month;
    selectedYear = widget.selectedDate.year;

  }


  List<int> getDaysInMonth(int year, int month) {
    final lastDayOfMonth = (month < 12) ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);
    return List.generate(lastDayOfMonth.day, (index) => index + 1);
  }

void updateDate() {
  final daysInMonth = getDaysInMonth(selectedYear, selectedMonth);
  final adjustedDay = (selectedDay > daysInMonth.last) ? daysInMonth.last : selectedDay;

  DateTime newDate = DateTime(selectedYear, selectedMonth, adjustedDay);
  
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  if (newDate.compareTo(today) == 0) {
    newDate = today.subtract(const Duration(days: 1));
  }

  widget.onDateChanged(newDate);
}



  @override
  Widget build(BuildContext context) {
    final days = getDaysInMonth(selectedYear, selectedMonth);
    final dayItems = days.map<DropdownMenuItem<int>>(
      (day) => DropdownMenuItem(value: day, child: Text('$day')),
    ).toList();

    final monthItems = List<DropdownMenuItem<int>>.generate(
      12,
      (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
    );

    final yearItems = List<DropdownMenuItem<int>>.generate(
      DateTime.now().year - 1855 + 1,
      (i) => DropdownMenuItem(value: 1855 + i, child: Text('${1855 + i}')),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('HISTORICAL AVERAGE DAYTIME TEMPERATURE = ', style: TextStyle(fontSize: 20, color: AppColors.red)),
        DropdownButton<int>(
         
          value: selectedDay,
          items: dayItems,
          onChanged: (int? newValue) {
            setState(() {
              selectedDay = newValue!;
              updateDate();
            });
          },
        ),
        Container(width: 10, height: 20, color: Colors.transparent), // Separator
        DropdownButton<int>(
      
          value: selectedMonth,
          items: monthItems,
          onChanged: (int? newValue) {
            setState(() {
              selectedMonth = newValue!;
              updateDate();
            });
          },
        ),
      
        DropdownButton<int>(
          value: selectedYear,
          items: yearItems,
          onChanged: (int? newValue) {
            setState(() {
              selectedYear = newValue!;
              updateDate();
            });
          },
        ),
        Container(width: 10, height: 20, color: Colors.transparent), // Separator
       Text(": ${widget.historicalTemperature}", style: const TextStyle(fontSize: 20, color: AppColors.red)),

      ],
    );
  }
}

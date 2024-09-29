import 'package:flutter/material.dart';

class YearPickerWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onYearChanged;
  final DateTime firstDate;
  final DateTime? lastDate;

  const YearPickerWidget({
    Key? key,
    required this.selectedDate,
    required this.onYearChanged,
    required this.firstDate,
    this.lastDate,
  }) : super(key: key);

  void _pickYear(BuildContext context) async {
    final DateTime effectiveLastDate = lastDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: effectiveLastDate,
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null && picked != selectedDate) {
      onYearChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _pickYear(context),
      child: const Text('Select Year (tage auch möglich)'),
    );
  }
}

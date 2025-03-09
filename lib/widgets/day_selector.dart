import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final List<bool> selectedDays;
  final Function(List<bool>) onChanged;

  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        return InkWell(
          onTap: () {
            final newDays = List<bool>.from(selectedDays);
            newDays[index] = !newDays[index];
            onChanged(newDays);
          },
          child: Container(
            width: 35,
            height: 35,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: selectedDays[index] ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.circular(17.5),
            ),
            child: Center(
              child: Text(
                days[index],
                style: TextStyle(
                  color: selectedDays[index] ? Colors.white : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

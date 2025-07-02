import 'package:flutter/material.dart';

class YesNoOptionWidget extends StatelessWidget {
  final int taskType;
  final String? selectedOption;
  final ValueChanged<String?> onChanged;

  const YesNoOptionWidget({
    super.key,
    required this.taskType,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> options = [];

    if (taskType == 2 || taskType == 3) {
      options = [
        {'label': 'Health Okay', 'value': 'YES'},
        {'label': 'Health Not Okay', 'value': 'NO'},
      ];
    } else if (taskType == 6) {
      options = [
        {'label': 'Pregnancy Confirmed', 'value': 'YES'},
        {'label': 'Pregnancy Not Confirmed', 'value': 'NO'},
      ];
    } else if (taskType == 10) {
      options = [
        {'label': 'Yes', 'value': 'YES'},
        {'label': 'No', 'value': 'NO'},
      ];
    }

    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option['label']!),
          value: option['value']!,
          groupValue: selectedOption,
          onChanged: onChanged,
        );
      }).toList(),
    );
  }
}

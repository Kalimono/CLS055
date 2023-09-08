import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  final ValueChanged<String> onSelectOption;
  final String selectedValue; // Pass the currently selected value

  MyDropdownButton({
    required this.onSelectOption,
    required this.selectedValue, // Add the selected value as a parameter
  });

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  List<String> list = <String>['all', 'done', 'undone'];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) {
        return list.map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      },
      onSelected: (String value) {
        widget.onSelectOption(value);
      },
      // Specify the selected value here
      initialValue: widget.selectedValue,
    );
  }
}

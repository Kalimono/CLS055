import 'package:flutter/material.dart';

class CustomDropdownButton extends StatefulWidget {
  final ValueChanged<String> onSelectOption;
  final String selectedValue;

  const CustomDropdownButton({
    super.key,
    required this.onSelectOption,
    required this.selectedValue,
  });

  @override
  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  List<String> list = <String>['all', 'done', 'undone'];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.black,
        size: 32.0,
      ),
      itemBuilder: (BuildContext context) {
        return list.map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Padding(
              // Add padding to the child
              padding: const EdgeInsets.all(16.0),
              child: Text(value),
            ),
          );
        }).toList();
      },
      onSelected: (String value) {
        widget.onSelectOption(value);
      },
      initialValue: widget.selectedValue,
    );
  }
}

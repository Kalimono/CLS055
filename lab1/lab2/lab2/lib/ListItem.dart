// import 'package:flutter/material.dart';

class ListItem {
  final String text;
  final bool isChecked;
  late final String id;

  ListItem({
    required this.text,
    required this.isChecked,
    required this.id,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      text: json['title'],
      isChecked: json['isChecked'],
      id: json['id'],
    );
  }
  // @override
  // _ListItemState createState() => _ListItemState();

  // void tapped(bool isChecked) {
  //   isChecked = !isChecked;
  // }
}

// class _ListItemState extends State<ListItem> {
//   bool isChecked = false;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Row(
//         children: [
//           Checkbox(
//             value: isChecked,
//             onChanged: (value) {},
//           ),
//           Expanded(
//             child: Text(
//               widget.text,
//               style: TextStyle(
//                 fontSize: 20,
//                 decoration: isChecked
//                     ? TextDecoration.lineThrough
//                     : TextDecoration.none,
//               ),
//             ),
//           ),
//           IconButton(
//             alignment: Alignment.centerRight,
//             icon: Icon(Icons.close),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

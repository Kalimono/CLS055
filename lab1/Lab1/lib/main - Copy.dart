import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> list = [];

  bool showAll = true;
  bool showDone = false;
  bool showUndone = false;

  void addItem(String text) {
    setState(() {
      list.add(ListItem(
        text: text,
        isChecked: false,
        onChecked: (bool value) {
          true;
        },
      ));
    });
  }

  void updateFilters(String selectedOption) {
    setState(() {
      switch (selectedOption) {
        case 'all':
          showAll = true;
          showDone = false;
          showUndone = false;
          break;
        case 'done':
          showAll = false;
          showDone = true;
          showUndone = false;
          break;
        case 'undone':
          showAll = false;
          showDone = false;
          showUndone = true;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CLS055 TODO",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          MyDropdownButton(
            onSelectOption: (selectedOption) {
              updateFilters(selectedOption);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          ListItem listItem = list[index];
          // final todoItem = list[index];

          // Check if the item should be displayed based on the flags
          if ((showAll) ||
              (showDone && listItem.isChecked) ||
              (showUndone && !listItem.isChecked)) {
            return Column(
              children: <Widget>[
                if (index > 0)
                  Divider(
                    height: 1,
                    thickness: 2,
                  ),
                ListTile(
                  title: ListItem(
                    text: listItem.text,
                    isChecked: listItem.isChecked,
                    onChecked: (isChecked) {
                      setState(() {
                        listItem.tapped(isChecked);
                      });
                    },
                  ),
                ),
              ],
            );
          } else {
            // Return an empty container if the item should be hidden
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEventPage(addItemCallback: addItem),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final String text;
  final bool isChecked;
  final ValueChanged<bool> onChecked;

  ListItem({
    required this.text,
    required this.isChecked,
    required this.onChecked,
  });

  @override
  _ListItemState createState() => _ListItemState();

  void tapped(bool isChecked) {
    isChecked = !isChecked;
  }
}

class _ListItemState extends State<ListItem> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Checkbox(
            value: widget.isChecked,
            onChanged: (bool? value) {
              widget.onChecked(value ?? false);
            },
          ),
          Expanded(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                decoration: widget.isChecked
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          IconButton(
            alignment: Alignment.centerRight,
            icon: Icon(Icons.close),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class MyDropdownButton extends StatefulWidget {
  final Function(String) onSelectOption;

  const MyDropdownButton({super.key, required this.onSelectOption});

  @override
  State<MyDropdownButton> createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  List<String> list = <String>['all', 'done', 'undone'];

  late String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: null, // Set the value to null initially
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;

          widget.onSelectOption(dropdownValue);
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class AddEventPage extends StatefulWidget {
  final Function(String) addItemCallback;

  const AddEventPage({required this.addItemCallback});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CLS055 TODO",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(width: 2.0),
                ),
                contentPadding: EdgeInsets.all(10),
                hintText: "Enter event name",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    widget.addItemCallback(_controller.text);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      Text('Add'),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectionButton extends StatefulWidget {
  final String title;
  final Function(String) onSelectionButtonTap;
  final bool isSelected;

  const SelectionButton({
    Key? key,
    required this.title,
    required this.onSelectionButtonTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  _SelectionButtonState createState() => _SelectionButtonState();
}

class _SelectionButtonState extends State<SelectionButton> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.onSelectionButtonTap(widget.title);
            isSelected = !isSelected;
          });
        },
      ),
    );
  }
}
// Widget _list() {
//   var names = ["Eat", "Sleep", "Study"];

//   var list = List.generate(10, (index) => names[index % 3]);

//   return ListView.builder(
//     itemBuilder: (context, index) => ListItem(list[index]),
//     itemCount: list.length,
//   );
// }

// Widget _item(text) {
//   return ListTile(
//     title: Text(text),
//     subtitle: Text("subtitle"),
//     // shape: Border.all(),
//   );
// }

// class MyWidget extends StatefulWidget {
//   String text;
//   bool isChecked = false;

//   const MyWidget(this.text);

//   void setState() {
//     isChecked = !isChecked;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: [
//           Checkbox(
//               value: isChecked,
//               onChanged: (value) {
//                 setState();
//               }),
//           Text(
//             text,
//             style: TextStyle(fontSize: 20),
//           ),
//           IconButton(
//             icon: Icon(Icons.remove),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SelectionButton extends StatefulWidget {
//   final String title;
//   final Function(String) onSelectionButtonTap;
//   final bool isSelected;

//   const SelectionButton({
//     Key? key,
//     required this.title,
//     required this.onSelectionButtonTap,
//     required this.isSelected,
//   }) : super(key: key);

//   @override
//   _SelectionButtonState createState() => _SelectionButtonState();
// }

// class _SelectionButtonState extends State<SelectionButton> {
//   bool isSelected = false;

//   @override
//   void initState() {
//     super.initState();
//     isSelected = widget.isSelected;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             widget.onSelectionButtonTap(widget.title);
//             isSelected = !isSelected;
//           });
//         },
//       ),
//     );
//   }
// }
// Widget _list() {
//   var names = ["Eat", "Sleep", "Study"];

//   var list = List.generate(10, (index) => names[index % 3]);

//   return ListView.builder(
//     itemBuilder: (context, index) => ListItem(list[index]),
//     itemCount: list.length,
//   );
// }

// Widget _item(text) {
//   return ListTile(
//     title: Text(text),
//     subtitle: Text("subtitle"),
//     // shape: Border.all(),
//   );
// }

// class MyWidget extends StatefulWidget {
//   String text;
//   bool isChecked = false;

//   const MyWidget(this.text);

//   void setState() {
//     isChecked = !isChecked;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Row(
//         children: [
//           Checkbox(
//               value: isChecked,
//               onChanged: (value) {
//                 setState();
//               }),
//           Text(
//             text,
//             style: TextStyle(fontSize: 20),
//           ),
//           IconButton(
//             icon: Icon(Icons.remove),
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

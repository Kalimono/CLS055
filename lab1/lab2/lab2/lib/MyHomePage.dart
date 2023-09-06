import 'package:flutter/material.dart';
import 'package:lab2/Networking.dart';
import 'ListItem.dart';
import 'AddEventPage.dart';
import 'MyDropdownButton.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Networking networking = Networking();

  List<ListItem> list = [];

  Map<int, bool> checkedStates = {};

  bool showAll = true;
  bool showDone = false;
  bool showUndone = false;

  void addItem(String text) {
    setState(() {
      final newItem = ListItem(
          text: text,
          isChecked: false,
          id: networking.postData(text, false).toString());
      checkedStates[list.indexOf(newItem)] = false;
      // newItem.id = networking.postData(text, false) as String;
      print("Adding item $newItem ${newItem.id}");
      list.add(newItem);
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

  void updateCheckedState(int index, bool isChecked) {
    setState(() {
      print("Updating checked state for index $index $isChecked");
      checkedStates[index] = isChecked;
      networking.putData(list[index], checkedStates[index] ?? false);
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
          final listItem = list[index];
          bool isChecked = checkedStates[index] ?? false;

          if ((showAll) ||
              (showDone && isChecked) ||
              (showUndone && !isChecked)) {
            return Column(
              children: <Widget>[
                if (index > 0)
                  Divider(
                    height: 1,
                    thickness: 2,
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Checkbox(
                        value: checkedStates[index] ?? false,
                        onChanged: (bool? value) {
                          updateCheckedState(index, value ?? false);
                        },
                      ),
                      Expanded(
                        child: Text(
                          listItem.text,
                          style: TextStyle(
                            fontSize: 20,
                            decoration: checkedStates[index] ?? false
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
                )
              ],
            );
          } else {
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

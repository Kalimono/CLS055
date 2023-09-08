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

  List<dynamic> list = [];
  List<dynamic> serverList = [];

  Map<int, bool> checkedStates = {};

  String selectedOption = 'all';

  bool showAll = true;
  bool showDone = false;
  bool showUndone = false;

  @override
  void initState() {
    super.initState();
    networking.fetchTodoItems().then((value) {
      setItemListFromServer(value);
    });
  }

  void addItem(String text) {
    print('server: $serverList');
    print('list: $list');
    setState(() {
      final newItem = ListItem(text: text, isChecked: false, id: '');
      checkedStates[list.indexOf(newItem)] = false;

      networking.testPostData(text).then((value) {
        newItem.id = value;
      });
      list.add(newItem);
    });
  }

  void setItemListFromServer(List<dynamic> listFromServer) {
    setState(() {
      serverList = listFromServer;
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

  void setListItems(List<dynamic> serverItemList) {
    print('setiing server ListItems<');
    setState(() {
      for (int i = 0; i < serverItemList.length; i++) {
        print(serverItemList[i]['text']);
        ListItem listItem = ListItem(
            text: serverItemList[i]['text'],
            isChecked: serverItemList[i]['isChecked'],
            id: serverItemList[i]['id']);
        list.add(listItem);
        checkedStates[i] = listItem.isChecked;
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

  void checkServerList() {
    List<String> idsToRemove = [];

    for (var serverItem in serverList) {
      String id = serverItem['id'];

      bool idExists = list.any((item) => item.id == id);

      if (!idExists) {
        ListItem newItem = ListItem(
          id: id,
          text: serverItem['title'],
          isChecked: serverItem['done'],
        );

        list.add(newItem);
        idsToRemove.add(id);
      }
    }

    // Remove items from serverList after the loop
    serverList.removeWhere((item) => idsToRemove.contains(item['id']));
  }

  void deleteItemAndData(int index) {
    final listItem = list[index];
    final itemId = listItem.id;

    networking.deleteData(itemId).then((_) {
      setState(() {
        list.removeAt(index);
        checkedStates.remove(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    checkServerList();
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
              setState(() {
                this.selectedOption = selectedOption;
                updateFilters(selectedOption);
              });
            },
            selectedValue: selectedOption, // Pass the selected option
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
                    height: 2, // Adjusted height
                    thickness: 2,
                  ),
                Container(
                  padding: EdgeInsets.all(16), // Adjusted padding
                  child: Row(
                    children: [
                      Checkbox(
                        value: checkedStates[index] ?? false,
                        onChanged: (bool? value) {
                          updateCheckedState(index, value ?? false);
                        },
                      ),
                      SizedBox(width: 16), // Added spacing
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
                        icon: Icon(Icons.close),
                        onPressed: () {
                          deleteItemAndData(index);
                        },
                      ),
                    ],
                  ),
                ),
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

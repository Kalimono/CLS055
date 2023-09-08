import 'package:flutter/material.dart';
import 'Networking.dart';
import 'ListItem.dart';
import 'AddEventPage.dart';
import 'CustomDropdownButton.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
    setState(() {
      final newItem = ListItem(text: text, isChecked: false, id: '');
      checkedStates[list.indexOf(newItem)] = false;
      networking.postNewListItem(text).then((value) {
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
    setState(() {
      for (int i = 0; i < serverItemList.length; i++) {
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
        title: const Text(
          "CLS055 TODO",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24.0),
        ),
        centerTitle: true,
        actions: [
          CustomDropdownButton(
            onSelectOption: (selectedOption) {
              setState(() {
                this.selectedOption = selectedOption;
                updateFilters(selectedOption);
              });
            },
            selectedValue: selectedOption,
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
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Checkbox(
                        value: checkedStates[index] ?? false,
                        onChanged: (bool? value) {
                          updateCheckedState(index, value ?? false);
                        },
                      ),
                      const SizedBox(width: 16),
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
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          deleteItemAndData(index);
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 2,
                  thickness: 2,
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AddEventPage extends StatefulWidget {
  final void Function(String text) addItemCallback;

  AddEventPage({required this.addItemCallback});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textFocusNode.dispose();
    super.dispose();
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _textEditingController,
              focusNode: _textFocusNode,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(width: 2.0),
                ),
                contentPadding: EdgeInsets.all(16), // Adjusted content padding
                hintText: "Enter event name",
              ),
            ),
            SizedBox(height: 16), // Added spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                  onPressed: () {
                    widget.addItemCallback(_textEditingController.text);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8), // Added spacing
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

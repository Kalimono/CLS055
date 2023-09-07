import 'package:flutter/material.dart';
import 'MyHomePage.dart';
import 'Networking.dart';

void main() {
  Networking networking = Networking();
  // networking.deleteAllData();
  // networking.postData("hello", false);
  // networking.postData();
  // print("Main: ${networking.testPostData()}");
  // print(networking.fetchTodoItems());

  // print("Main: $id");

  // print(networking.testFunction());

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

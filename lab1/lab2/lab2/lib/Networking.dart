import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lab2/ListItem.dart';

class Networking {
  static const String url = 'https://todoapp-api.apps.k8s.gu.se/';
  static const String apiKey = 'c035376f-b9b5-4542-953e-dbf69251dca3';

  Future<List<dynamic>> fetchTodoItems() async {
    final response = await http.get(Uri.parse(
        'https://todoapp-api.apps.k8s.gu.se/todos?key=c035376f-b9b5-4542-953e-dbf69251dca3'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonDataList = jsonDecode(response.body);
      // print(jsonDataList);
      // final List<ListItem> itemList = new List<ListItem>.empty(growable: true);
      // jsonDataList.map((jsonData) => ListItem.fromJson(jsonData)).toList();

      return jsonDataList;
    } else {
      throw Exception('Failed to load album');
    }
  }

  void deleteAllData() async {
    List<dynamic> lista = await fetchTodoItems();

    for (var item in lista) {
      deleteData(item['id']);
    }

    lista = await fetchTodoItems();

    for (var item in lista) {
      print(item['id']);
    }

    // final items = fetchTodoItems();
    // printTodoItems(items as List<ListItem>);

    // final url = Uri.parse(
    //     'https://todoapp-api.apps.k8s.gu.se/todos?key=c035376f-b9b5-4542-953e-dbf69251dca3');
    // final headers = {'Content-Type': 'application/json'};

    // final response = await http.delete(
    //   url,
    //   headers: headers,
    // );

    // if (response.statusCode == 200) {
    //   print('DELETE request successful');
    //   print('Response data: ${response.body}');
    // } else {
    //   print(
    //       'Failed to make DELETE request. Status code: ${response.statusCode}');
    //   print('Response data: ${response.body}');
    // }
  }

  Future<String> postData(String text, bool isChecked) async {
    final url = Uri.parse(
        'https://todoapp-api.apps.k8s.gu.se/todos?key=c035376f-b9b5-4542-953e-dbf69251dca3');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"title": text, "done": isChecked.toString()}),
    );

    if (response.statusCode == 200) {
      print('POST request successful');
      print('Response data: ${response.body}');

      final List<dynamic> data = jsonDecode(response.body);
      return data.last['id'];
    } else {
      print('Failed to make POST request. Status code: ${response.statusCode}');
      print('Response data: ${response.body}');
    }

    return '';
  }

  String testFunction() {
    String result = testPostData() as String;

    print("Later: $result");

    return result;
  }

  Future<String> testPostData() async {
    String? testString;

    testString = await postData("TEST", false);

    print("Function: $testString");

    return testString;
  }

//   Future<String> testPostData() async {
//   String? testString;

//   testString = await postData("TEST", false);

//   return testString;
// }

  // Future<String> testPostData() async {
  //   String? testString;

  //   testString = await postData("TEST", false);

  //   postData("TEST", false).then((val) {
  //     testString = val;

  //     return testString;
  //   });

  //   return testString ?? '';
  // }

  // String testPostData() {
  //   String? testString;

  //   postData("TEST", false).then((val) {
  //     testString = val;

  //     return testString;
  //   });

  //   return testString ?? '';
  // }

  void putData(ListItem listItem, bool? isChecked) async {
    final String id = listItem.id.toString();
    print("Updating item with id ${listItem.text} $id $isChecked");
    final url = Uri.parse(
        'https://todoapp-api.apps.k8s.gu.se/todos/$id?key=c035376f-b9b5-4542-953e-dbf69251dca3');

    final headers = {'Content-Type': 'application/json'};
    print("Updating item with id ${listItem.text} $id $isChecked");
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode({"title": listItem.text, "done": isChecked}),
    );

    if (response.statusCode == 200) {
      print('PUT request successful');
      print('Response data: ${response.body}');
    } else {
      print('Failed to make PUT request. Status code: ${response.statusCode}');
      print('Response data: ${response.body}');
    }
  }

  void deleteData(String id) async {
    print("Deleting item with id $id");
    final url = Uri.parse(
        'https://todoapp-api.apps.k8s.gu.se/todos/$id?key=c035376f-b9b5-4542-953e-dbf69251dca3');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.delete(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('DELETE request successful');
      print('Response data: ${response.body}');
    } else {
      print(
          'Failed to make DELETE request. Status code: ${response.statusCode}');
      print('Response data: ${response.body}');
    }
  }
}

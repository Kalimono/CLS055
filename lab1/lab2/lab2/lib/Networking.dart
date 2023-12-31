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
      final List<dynamic> jsonDataList = await jsonDecode(response.body);

      return jsonDataList;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<String> postData(String text) async {
    final url = Uri.parse(
        'https://todoapp-api.apps.k8s.gu.se/todos?key=c035376f-b9b5-4542-953e-dbf69251dca3');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"title": text, "done": false}),
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

  Future<String> postNewListItem(String text) {
    return postData(text);
  }

  void putData(ListItem listItem, bool? isChecked) async {
    final url = Uri.parse(
        'https://todoapp-api.apps.k8s.gu.se/todos/${listItem.id}?key=c035376f-b9b5-4542-953e-dbf69251dca3');

    final headers = {'Content-Type': 'application/json'};

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

  Future<void> deleteData(String id) async {
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

  void deleteAllData() async {
    List<dynamic> lista = await fetchTodoItems();

    for (var item in lista) {
      deleteData(item['id']);
    }
  }
}

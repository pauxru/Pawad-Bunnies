import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiHandler {
  String host = "http://pawadtech.one:8080";
  //static const String host = '${dotenv.env['API_ENDPOINT']}';

  Future<void> APIping() async {
    try {
      var response = await http.get(Uri.parse(host));
      if (response.statusCode != 200) {
        throw Exception('Server not reachable');
      }
    } catch (e) {
      print('Error pinging server: $e');
    }
  }

/*
  Future<List<Map<String, dynamic>>> APIget(String uri) async {
    print("URI ::: " + '$host$uri');
    var data = null;
    try {
      var response = await http.get(Uri.parse('$host$uri'));
      var tt = response.headers;
      print('Fetched data: $tt');
      if (response.statusCode == 200) {
        data = json.decode(response.body);
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    print('Fetched data: $data');
    return data;
  }
*/
  Future<List<Map<String, dynamic>>> APIget(String uri) async {
    print("URI ::: " + '$host$uri');
    var data = null;
    try {
      var response = await http.get(Uri.parse('$host$uri'));
      var tt = response.headers;
      print('Fetched data: $tt');
      if (response.statusCode == 200) {
        data = json.decode(response.body);
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    print('Fetched data: $data');
    return data;
  }

  Future<List<Map<String, dynamic>>> fetchDataAPI() async {
    print('Here at _fetchData');
    return await APIget("/tasks");
  }

  Future<int> APIpost(String uri, Map<String, dynamic> postData) async {
    String url = '$host$uri'; // Ensure `host` is correctly set
    print("POST URI ::: $url");
    print("ToPost Data ::: $postData");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        var data = json.decode(response.body);
        print('Created Rabbit: $data');
      } else {
        print('Failed to create Rabbit: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }

      return 201;
    } catch (e) {
      print('Error creating Rabbit: $e');
      return 0;
    }
  }
}

class Task {
  final int id;
  final String title;
  final String description;

  Task({required this.id, required this.title, required this.description});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }
}

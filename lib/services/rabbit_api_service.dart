import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

import '../models/rabbit.dart';
import '../constants/constants.dart';

class RabbitApiService {
  final String baseUrl = Constants.apiBaseUrl;

  Future<List<Rabbit>> getRabbits() async {
    final url = Uri.parse('${Constants.rabbitEndpoint}');
    print('[DEBUG] Sending GET request to: $url');

    final response = await http.get(url);
    print('[DEBUG] Status Code: ${response.statusCode}');
    print('[DEBUG] Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Rabbit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rabbits: ${response.body}');
    }
  }

  Future<Rabbit> createRabbit(Rabbit rabbit, File? imageFile) async {
    final uri = Uri.parse('${Constants.rabbitEndpoint}');
    print('[DEBUG] Sending POST request to: $uri');

    var request = http.MultipartRequest('POST', uri);

    // Add form fields from rabbit
    final fields = rabbit.toMultipartFields();
    print('[DEBUG] Adding fields to request: $fields');
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add image if provided
    if (imageFile != null) {
      print('[DEBUG] Attaching image file: ${imageFile.path}');
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: basename(imageFile.path),
        contentType: MediaType('image', 'jpeg'),
      ));
    } else {
      print('[DEBUG] No image file provided.');
    }

    print('[DEBUG] Sending multipart request...');
    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);
    print('[DEBUG] Status Code: ${response.statusCode}');
    print('[DEBUG] Response Body: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Rabbit.fromJson(json);
    } else {
      throw Exception('Failed to create rabbit: ${response.body}');
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

class ImageUploadService {
  final String baseUrl = Constants.apiBaseUrl;

  /// Upload a new image (POST)
  Future<String?> uploadImage(File imageFile) async {
    final uri = Uri.parse('$baseUrl/images');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['url']; // assuming the API returns image URL
    } else {
      print('Upload failed: ${response.body}');
      return null;
    }
  }

  /// Get image metadata or URL (GET)
  Future<Map<String, dynamic>?> getImage(String imageId) async {
    final uri = Uri.parse('$baseUrl/images/$imageId');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to get image: ${response.body}');
      return null;
    }
  }

  /// Update image (e.g. replace with new file)
  Future<bool> updateImage(String imageId, File newImageFile) async {
    final uri = Uri.parse('$baseUrl/images/$imageId');

    final request = http.MultipartRequest('PUT', uri)
      ..files.add(await http.MultipartFile.fromPath('file', newImageFile.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200;
  }

  /// Delete image (DELETE)
  Future<bool> deleteImage(String imageId) async {
    final uri = Uri.parse('$baseUrl/images/$imageId');
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }
}

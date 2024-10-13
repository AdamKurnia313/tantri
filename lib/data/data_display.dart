import 'dart:convert';
import 'package:http/http.dart' as http;

import 'data_model.dart';

class ApiService {
  Future<Welcome?> fetchArticles() async {
    final response = await http.get(
        Uri.parse('https://my-json-server.typicode.com/Fallid/codelab-api/db'));

    if (response.statusCode == 200) {
      return Welcome.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
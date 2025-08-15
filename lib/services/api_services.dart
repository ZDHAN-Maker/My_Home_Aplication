import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "https://example.com/api";

  Future<Map<String, dynamic>> getData() async {
    final response = await http.get(Uri.parse("$baseUrl/data"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/word_model.dart';

class WordApiDatasource {
  // Change this to your local IP when running on a physical device
  // e.g., 'http://192.168.1.100:3000'
  static const String baseUrl = 'http://10.0.2.2:3000'; // Android emulator localhost

  Future<List<WordModel>> getWords() async {
    final response = await http.get(Uri.parse('$baseUrl/words'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((e) => WordModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load words from API');
    }
  }
}

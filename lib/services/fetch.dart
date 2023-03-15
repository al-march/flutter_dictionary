
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/dto/user_dto.dart';
import '../models/dto/word_dto.dart';

Future<UserDto> fetchUser() async {
  var url = 'http://127.0.0.1:8080/api/v1/user/root';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var utf = utf8.decode(response.bodyBytes);
    return UserDto.fromJson(jsonDecode(utf));
  } else {
    throw Exception('Failed to load word user');
  }
}

Future<List<WordDto>> fetchUserSavedWords() async {
  var url = 'http://127.0.0.1:8080/api/v1/user/root/saved/mini';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    var utf = utf8.decode(response.bodyBytes);
    var json = jsonDecode(utf);

    if (json != null) {
      return (json as List).map((word) => WordDto.fromJson(word)).toList();
    }
    return List.empty();
  } else {
    throw Exception('Failed to load user words');
  }
}

Future<WordDto> fetchWord(String name) async {
  var url = 'http://127.0.0.1:8080/api/v1/word/$name';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var utf = utf8.decode(response.bodyBytes);
    return WordDto.fromJson(jsonDecode(utf));
  } else {
    throw Exception('Failed to load word: $name');
  }
}

Future<WordDto> fetchSaveWord(String name) async {
  var url = 'http://127.0.0.1:8080/api/v1/word/$name';
  final response = await http.post(Uri.parse(url));

  if (response.statusCode == 200) {
    var utf = utf8.decode(response.bodyBytes);
    return WordDto.fromJson(jsonDecode(utf));
  } else {
    throw Exception('Failed to load word: $name');
  }
}

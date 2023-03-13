import 'dart:convert';

import 'package:dictionary/components/template/center_scroll.dart';
import 'package:dictionary/models/dto/word_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/word_card.dart';
import '../components/word_search.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  WordDto? wordDto;

  onSubmit(String word) async {
    try {
      var dto = await fetchWord(word);
      setState(() {
        wordDto = dto;
      });
    } catch (err) {
      var snackBar = const SnackBar(
        content: Text('Не удалось загрузить определения ('),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Словарь'),
      ),
      body: CenterScroll(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
              child: Column(
                children: [
                  SearchWord(onSubmit: onSubmit),
                  const SizedBox(height: 20),
                  WordCard(dto: wordDto)
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

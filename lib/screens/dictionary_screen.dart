import 'dart:convert';

import 'package:dictionary/components/template/app_scroll.dart';
import 'package:dictionary/models/dto/user_dto.dart';
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
  var tabIndex = 0;
  UserDto? user;
  List<WordDto> savedWords = [];

  @override
  initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    try {
      var userDto = await fetchUser();
      var wordsDto = await fetchUserSavedWords();

      setState(() {
        user = userDto;
        savedWords = wordsDto;
      });
    } catch (e) {
      showSnackbar(context, "Не удалось загрузить данные");
    }
  }

  saveWord(WordDto word) async {
    try {
      var saved = await fetchSaveWord(word.name);
      setState(() {
        savedWords.add(saved);
        showSnackbar(context, 'Слово ${word.name} сохранено!');
      });
    } catch (e) {
      showSnackbar(context, 'Не удалось сохранить слово "${word.name}" 😕');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tab;
    switch (tabIndex) {
      case 0:
        tab = SearchTab(onSaveWord: saveWord);
        break;
      case 1:
        tab = SavedWordsTab(words: savedWords);
        break;
      default:
        tab = const Center(child: Text('page not found 😕'));
    }

    return Navigation(
      onSelectTab: (index) {
        setState(() {
          tabIndex = index;
        });
      },
      selectedIndex: tabIndex,
      savedWordsLength: savedWords.length,
      appBar: AppBar(
        title: const Text('Словарь'),
      ),
      body: tab,
    );
  }
}

class SearchTab extends StatefulWidget {
  const SearchTab({
    super.key,
    this.onSaveWord,
  });

  final Function(WordDto word)? onSaveWord;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  WordDto? wordDto;

  onSubmit(String word) async {
    try {
      var dto = await fetchWord(word);
      setState(() {
        wordDto = dto;
      });
    } catch (err) {
      showSnackbar(context, 'Не удалось загрузить определение "$word" 😕');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScroll(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
            child: Column(
              children: [
                SearchWord(onSubmit: onSubmit),
                const SizedBox(height: 20),
                WordCard(
                  dto: wordDto,
                  onSave: widget.onSaveWord,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SavedWordsTab extends StatelessWidget {
  const SavedWordsTab({
    super.key,
    this.words = const <WordDto>[],
  });

  final List<WordDto> words;

  @override
  Widget build(BuildContext context) {
    return AppScroll(
      child: Column(
        children: words.map((e) => WordCard(dto: e)).toList(),
      ),
    );
  }
}

class Navigation extends StatelessWidget {
  const Navigation({
    super.key,
    this.selectedIndex = 0,
    this.savedWordsLength = 0,
    this.appBar,
    this.body,
    this.onSelectTab,
  });

  final int savedWordsLength;
  final int selectedIndex;
  final PreferredSizeWidget? appBar;
  final Widget? body;

  final Function(int index)? onSelectTab;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 800,
                destinations: [
                  const NavigationRailDestination(
                    icon: Icon(Icons.search),
                    label: Text('Search'),
                  ),
                  NavigationRailDestination(
                    icon: Badge(
                      label: Text(savedWordsLength.toString()),
                      child: const Icon(Icons.save),
                    ),
                    label: const Text('Saved'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  onSelectTab?.call(value);
                },
              ),
            ),
            Expanded(child: body ?? const SizedBox()),
          ],
        ),
      );
    });
  }
}

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
  var url = 'http://127.0.0.1:8080/api/v1/user/root/saved';
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

showSnackbar(BuildContext context, String message) {
  var snackBar = SnackBar(
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

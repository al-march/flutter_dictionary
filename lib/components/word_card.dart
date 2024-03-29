import 'package:flutter/material.dart';

import '../models/dto/word_dto.dart';

class WordCard extends StatefulWidget {
  const WordCard({
    super.key,
    this.dto,
    this.onSave,
  });

  final WordDto? dto;
  final Function(WordDto word)? onSave;

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  String definition = '';
  String ru = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var colors = theme.colorScheme;

    if (widget.dto != null) {
      if (widget.dto != null) {
        if (widget.dto!.definitions.isNotEmpty) {
          var definitions = widget.dto!.definitions;
          setState(() {
            definition = definitions[0].meaning;
          });
        }

        if (widget.dto!.translation?.ru != null) {
          setState(() {
            ru = widget.dto!.translation!.ru!;
          });
        }
      }

      return Card(
        elevation: 10,
        color: colors.surface,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.dto!.name,
                    style: const TextStyle(fontSize: 30),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    widget.dto!.type,
                    style: TextStyle(
                      fontSize: 15,
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Text(
                          ru,
                          style: TextStyle(
                            color: colors.onSurface.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(child: Text(definition)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          widget.onSave?.call(widget.dto!);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: const Text('Учить'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

class WordCardMini extends StatelessWidget {
  const WordCardMini({super.key, required this.dto, this.onInfo});

  final WordDto dto;
  final Function? onInfo;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    String translate = '';
    if (dto.translation != null) {
      if (dto.translation!.ru != null) {
        translate = dto.translation!.ru!;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(children: [
                ListTile(
                  title: Row(children: [
                    Text(
                      dto.name,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dto.type,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ]),
                  subtitle: Text(translate),
                ),
              ]),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                onInfo?.call();
              },
              icon: const Icon(Icons.info),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/dto/word_dto.dart';

class WordCard extends StatefulWidget {
  const WordCard({
    super.key,
    this.dto,
    this.onSave,
  });

  final WordDto? dto;
  final Function? onSave;

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  String definition = '';
  String ru = '';
  List<DefenitionPanel> panels = [];

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
            definition = definitions.removeAt(0).meaning;
            panels = generateList(definitions);
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
                          widget.onSave?.call();
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

class DefenitionPanel {
  bool isExpanded = false;
  DefinitionDto dto;

  DefenitionPanel({
    required this.dto,
  });
}

generateList(List<DefinitionDto> list) {
  return list.map((dto) => DefenitionPanel(dto: dto)).toList();
}

class WordCardDefsList extends StatefulWidget {
  final List<DefenitionPanel> panels;

  const WordCardDefsList({
    super.key,
    required this.panels,
  });

  @override
  State<WordCardDefsList> createState() => _WordCardDefsListState();
}

class _WordCardDefsListState extends State<WordCardDefsList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            widget.panels[index].isExpanded = !isExpanded;
          });
        },
        children: widget.panels.map((def) {
          return ExpansionPanel(
            headerBuilder: (context, isExpand) {
              return ListTile(
                title: SizedBox(
                  child: Text(
                    def.dto.meaning,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
            body: ListTile(
              subtitle: Text(def.dto.meaning),
            ),
            isExpanded: def.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}

class WordDto {
  final String name;
  final String type;
  final String sounding;
  final List<DefinitionDto> definitions;
  final TranslationDto? translation;

  const WordDto({
    required this.name,
    required this.type,
    required this.sounding,
    required this.definitions,
    this.translation,
  });

  factory WordDto.fromJson(Map<String, dynamic> json) {
    var defJson = json['definitions'] as List;
    var defDtos = defJson.map((def) => DefinitionDto.fromJson(def)).toList();
    var translation = TranslationDto.fromJson(json['translate']);

    return WordDto(
      name: json['name'],
      type: json['type'],
      sounding: json['sounding'],
      definitions: defDtos,
      translation: translation,
    );
  }
}

class DefinitionDto {
  final String meaning;
  final List<String> examples;
  final List<String> seeAlso;

  const DefinitionDto({
    required this.meaning,
    required this.examples,
    required this.seeAlso,
  });

  factory DefinitionDto.fromJson(Map<String, dynamic> json) {
    return DefinitionDto(
      meaning: json['meaning'],
      examples: List.from(json['examples']),
      seeAlso: List.from(json['seeAlso']),
    );
  }
}

class TranslationDto {
  final String? ru;

  const TranslationDto({
    this.ru,
  });

  factory TranslationDto.fromJson(Map<String, dynamic> json) {
    return TranslationDto(ru: json['ru']);
  }
}

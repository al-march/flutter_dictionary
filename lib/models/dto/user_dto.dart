import 'package:dictionary/models/dto/word_dto.dart';

class UserDto {
  final int id;
  final String name;
  final String email;
  final String createdAt;
  final String updatedAt;

  UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

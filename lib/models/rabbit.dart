import 'package:intl/intl.dart';

class Rabbit {
  final String tagNo;
  final DateTime? birthday;
  final String breed;
  final String mother;
  final String father;
  final String sex;
  final String origin;
  final String diseases;
  final String comments;
  final String weight;
  final String priceSold;
  final String cage;
  final List<String> images;

  Rabbit({
    required this.tagNo,
    this.birthday,
    required this.breed,
    required this.mother,
    required this.father,
    required this.sex,
    required this.origin,
    required this.diseases,
    required this.comments,
    required this.weight,
    required this.priceSold,
    required this.cage,
    required this.images,
  });

  factory Rabbit.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        try {
          return DateFormat('dd/MM/yyyy').parse(dateString);
        } catch (_) {
          return null;
        }
      }
    }

    List<String> images = [];
    if (json['images'] is List) {
      images = List<String>.from(json['images']);
    } else if (json['images'] is String) {
      images = [json['images']];
    }

    return Rabbit(
      tagNo: json['tagNo'] ?? '',
      birthday: parseDate(json['birthday']),
      breed: json['breed'] ?? '',
      mother: json['mother'] ?? '',
      father: json['father'] ?? '',
      sex: json['sex'] ?? '',
      origin: json['origin'] ?? '',
      diseases: json['diseases'] ?? '',
      comments: json['comments'] ?? '',
      weight: json['weight'] ?? '',
      priceSold: json['price_sold'] ?? '',
      cage: json['cage'] ?? '',
      images: images,
    );
  }

  Map<String, String> toMultipartFields() {
    return {
      'tagNo': tagNo,
      'birthday': birthday?.toIso8601String() ?? '',
      'breed': breed,
      'mother': mother,
      'father': father,
      'sex': sex,
      'origin': origin,
      'diseases': diseases,
      'comments': comments,
      'weight': weight,
      'price_sold': priceSold,
      'cage': cage,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'tagNo': tagNo,
      'birthday': birthday?.toIso8601String(),
      'breed': breed,
      'mother': mother,
      'father': father,
      'sex': sex,
      'origin': origin,
      'diseases': diseases,
      'comments': comments,
      'weight': weight,
      'price_sold': priceSold,
      'cage': cage,
      'images': images,
    };
  }
}

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Localitation {
  int? id;

  String? postalCode;
  String? cityName;
  String? country;
  String? street;

  Localitation(
      {this.id, this.postalCode, this.cityName, this.country, this.street});

  factory Localitation.fromJson(Map<String, dynamic> json) => Localitation(
        id: json['id'],
        postalCode: json['postalCode'],
        cityName: json['cityName'],
        country: json['country'],
        street: json['street'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'postalCode': postalCode,
        'cityName': cityName,
        'country': country,
        'street': street
      };
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:friendshift/models/localitation_model.dart';
import 'package:friendshift/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Event {
  int? id;
  Localitation? localitation;
  User? user;
  String? details;
  String? image;
  String? startTimePlanned;
  String? endTimePlanned;
  String? startTimeActual;
  String? endTimeActual;
  double? price;
  bool? isPublic;

  Event(
      {this.id,
      this.localitation,
      this.user,
      this.details,
      this.image,
      this.startTimePlanned,
      this.endTimePlanned,
      this.startTimeActual,
      this.endTimeActual,
      this.price,
      this.isPublic});

  static Localitation locaMap(String json) {
    var loca;

    Map<String, dynamic> locamap = jsonDecode(json);
    loca = Localitation.fromJson(locamap);
    return loca;
  }

  static User userMap(String json) {
    var user;

    Map<String, dynamic> usermap = jsonDecode(json);
    user = User.fromJson(usermap);
    return user;
  }

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        localitation: Localitation.fromJson(json['localitation']),
        user: User.fromJson(json['user']),
        details: json['details'],
        image: json['image'],
        startTimePlanned: json['startTimePlanned'],
        startTimeActual: json['startTimeActual'],
        endTimeActual: json['endTimeActual'],
        endTimePlanned: json['endTimePlanned'],
        price: json['price'],
        isPublic: json['isPublic'],
      );

  Map<String, dynamic> toJson() {

    Map <String, dynamic>? userMap = this.user != null ? this.user?.toJson() : null;

    Map <String, dynamic>? localitationMap = this.localitation != null ? this.localitation?.toJson() : null;

    return {
      'id': id,
      'localitation': localitationMap,
      'user': userMap,
      'details': details,
      'image': image,
      'startTimePlanned': startTimePlanned,
      ' endTimePlanned': endTimePlanned,
      'startTimeActual': startTimeActual,
      'endTimeActual': endTimeActual,
      'price': price,
      'isPublic': isPublic
    };
  }
}

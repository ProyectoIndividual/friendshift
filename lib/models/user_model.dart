import 'dart:convert';
import 'dart:core';

import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

import 'event_model.dart';
import 'invitation_model.dart';
import 'localitation_model.dart';

@JsonSerializable()
class User {
  int? id;
  String? name;
  String? surnames;
  String? description;
  String? email;
  String? phone;
  String? image;
  String? password;
  String? registrationDate;
  String? token;
  Localitation? localitation;
  //List<Event>? events;
  //List<Invitation>? invitations;

  User({
    this.id,
    this.name,
    this.surnames,
    this.description,
    this.email,
    this.phone,
    this.image,
    this.password,
    this.registrationDate,
    this.token,
    this.localitation,
    // this.events,
//this.invitations
  });

  /* User(
      int id,
      String name,
      String surnames,
      String description,
      String email,
      String phone,
      Uint8List image,
      String password,
      DateTime registrationDate,
      String token,
      Localitation localitation,
      List<Event> events,
      List<Invitation> invitations) {
    this.id = id;
    this.name = name;
    this.surnames = surnames;
    this.email = email;
    this.phone = phone;
    this.image = image;
    this.password = password;
    this.registrationDate = registrationDate;
    this.token = token;
    this.localitation = localitation;
    this.events = events;
    this.invitations = invitations;
  }*/
  static Localitation localitationMap(String json) {
    var loca;

    Map<String, dynamic> locamap = jsonDecode(json);
    loca = Localitation.fromJson(locamap);
    return loca;
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        surnames: json['surnames'],
        description: json['description'],
        email: json['email'],
        phone: json['phone'],
        image: json['image'],
        password: json['password'],
        registrationDate: json['registrationDate'],
        token: json['token'],
        localitation: Localitation.fromJson(json['localitation']),
        // events: List<Event>.from(json['events'].map((x) => Event.fromJson(x))),
        //invitations: List<Invitation>.from( json['invitations'].map((x) => Invitation.fromJson(x)))
      );

  Map<String, dynamic> toJson() {
    String? localitation =
        this.localitation != null ? jsonEncode(this.localitation) : null;

    /*  List<String>? events = this.events != null
        ? this.events?.map((e) => jsonEncode(e)).toList()
        : null;

    List<String>? invitations = this.invitations != null
        ? this.invitations?.map((e) => jsonEncode(e)).toList()
        : null;*/

    return {
      'id': id,
      'name': name,
      'surnames': surnames,
      'description': description,
      'email': email,
      'phone': phone,
      'image': image,
      'password': password,
      'registrationDate': registrationDate,
      'token': token,
      'localitation': localitation,
      //  'events': events,
      // 'invitations': invitations
    };
  }
}

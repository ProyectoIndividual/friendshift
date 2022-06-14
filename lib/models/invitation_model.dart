import 'dart:convert';

import 'package:friendshift/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

import 'event_model.dart';

@JsonSerializable()
class Invitation {
  int? id;
  User? user;
  Event? event;

  double? invoiceAmount;
  double? discounet;
  double? totalAmount;
  bool? accept;

  Invitation({
    this.id,
    this.user,
    this.event,
    this.invoiceAmount,
    this.discounet,
    this.totalAmount,
    this.accept,
  });

  static Event eventMap(String json) {
    var event;

    Map<String, dynamic> eveamap = jsonDecode(json);
    event = Event.fromJson(eveamap);
    return event;
  }

  static User userMap(String json) {
    var user;

    Map<String, dynamic> usermap = jsonDecode(json);
    user = User.fromJson(usermap);
    return user;
  }

  factory Invitation.fromJson(Map<String, dynamic> json) => Invitation(
        id: json['id'],
        user: User.fromJson(json['user']),
        event: Event.fromJson(json['event']),
        invoiceAmount: json['invoiceAmount'],
        discounet: json['discounet'],
        totalAmount: json['totalAmount'],
        accept: json['accept'],
      );

  Map<String, dynamic> toJson() {


    Map <String, dynamic>? userMap = this.user != null ? this.user?.toJson() : null;
    Map <String, dynamic>? eventMap = this.event != null ? this.event?.toJson() : null;

    return {
      'id': id,
      'user': userMap,
      'event': eventMap,
      'invoiceAmount': invoiceAmount,
      'discounet': discounet,
      'totalAmount': totalAmount,
      'accept': accept,
    };
  }
}

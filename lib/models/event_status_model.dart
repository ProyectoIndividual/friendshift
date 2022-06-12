import 'dart:convert';

import 'package:friendshift/models/event_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class EventStatus {
  int? id;
  Event? event;
  String? timeAssigned;
  bool? end;

  EventStatus({this.id, this.event, this.timeAssigned, this.end});

  factory EventStatus.fromJson(Map<String, dynamic> json) => EventStatus(
        id: json['id'],
        event: Event.fromJson(json['event']),
        timeAssigned: json['timeAssigned'],
        end: json['end'],
      );

  Map<String, dynamic> toJson() {
    String? event = this.event != null ? jsonEncode(this.event) : null;

    return {'id': id, 'event': event, 'timeAssigned': timeAssigned, 'end': end};
  }
}

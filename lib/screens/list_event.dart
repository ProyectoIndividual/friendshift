import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendshift/models/event_model.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;
import 'package:friendshift/pages/page_event_info.dart';

class ListEvents extends StatelessWidget {
  ListEvents(this.events);

  final List<Event> events;

  @override
  Widget build(BuildContext context) => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final byte = base64Decode(event.image ?? helpData.base54Event);
          var image1 = Image.memory(byte);
          print("${event.localitation?.id}");

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: image1 == null
                    ? image1 as ImageProvider
                    : NetworkImage(helpData.url1),
              ),
              title: Text("${event.user?.name}  ${event.user?.surnames}"),
              subtitle: Text("${event.localitation?.cityName}"),
              onTap: () {
                print("object");
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => PageEventoInfo(evento: event)),
                );
              },
            ),
          );
        },
      );
}

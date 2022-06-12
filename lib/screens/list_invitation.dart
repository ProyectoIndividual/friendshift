import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:friendshift/models/event_model.dart';
import 'package:friendshift/models/invitation_model.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;
import 'package:friendshift/pages/page_event_info.dart';

class ListInvitations extends StatelessWidget {
  ListInvitations(this.invitations);

  final List<Invitation> invitations;

  @override
  Widget build(BuildContext context) => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: invitations.length,
        itemBuilder: (context, index) {
          final invitation = invitations[index];
          final byte =
              base64Decode(invitation.event!.image ?? helpData.base54Event);
          var image1 = Image.memory(byte);

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: image1 == null
                    ? image1 as ImageProvider
                    : NetworkImage(helpData.url1),
              ),
              title: Text(
                  "${invitation.event!.user?.name}  ${invitation.event!.user?.surnames}"),
              subtitle: Text("${invitation.event!.localitation?.cityName}"),
              onTap: () {
                if (invitation.event != null) {
                  Event event = new Event();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PageEventoInfo(
                            evento: invitation.event == null
                                ? event
                                : invitation.event!)),
                  );
                }
                print("object");
              },
            ),
          );
        },
      );
}

import 'package:flutter/material.dart';
import 'package:friendshift/models/invitation_model.dart';
import 'package:friendshift/screens/list_event.dart';
import 'package:friendshift/screens/list_invitation.dart';
import 'package:friendshift/services/api_service.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;
import '../screens/navigation_drawer.dart';

class PageInvitaciones extends StatefulWidget {
  const PageInvitaciones({Key? key}) : super(key: key);

  @override
  _PageInvitacionState createState() => _PageInvitacionState();
}

class _PageInvitacionState extends State<PageInvitaciones> {
  Future<List<Invitation>> invitations = getData();
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  static Future<List<Invitation>> getData() async {
    final invitations =
        await ApiService().getInvitationUser(helpData.user.id ?? 1);

    return invitations;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text("Eventos"),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder<List<Invitation>>(
        future: invitations,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final invitation = snapshot.data!;
            return ListInvitations(invitation);
          } else {
            return const Text("No Invitaciones");
          }
        },
      ),
    );
  }
}

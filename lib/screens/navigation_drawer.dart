import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:friendshift/models/user_model.dart';
import 'package:friendshift/pages/page_add_eventos.dart';
import 'package:friendshift/pages/page_eventos.dart';
import 'package:friendshift/pages/page_invitaciones.dart';
import 'package:friendshift/pages/page_user_info.dart';
import 'package:localstore/localstore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  User user = new User();
  late Uint8List bytes;
  Image? img;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //if (mounted) {}

   /* Future.delayed(Duration.zero, () async {
      await redUser();
    });*/
  }

  Future<void> redUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? json = prefs.getString("user");

    if (json != null) {
      final String nonull = json;
      print("Drawer $nonull");

      Map<String, dynamic> userMap = jsonDecode(nonull);
      user = User.fromJson(userMap);

      if (user.image != null) {
        bytes = base64Decode(user.image ??
            "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");
        print("EEE");
        img = Image.memory(bytes);
      }
      // setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Drawer(
        // ignore: unnecessary_this

        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        )),
      );

  Widget buildHeader(BuildContext context) => Material(
        color: Colors.purple.shade300,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PageUser()));
          },
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
            ),
            child: Column(
              children: [
                CircleAvatar(
                    radius: 52, backgroundImage: NetworkImage(helpData.url1)),
                SizedBox(height: 12),
                Text(
                  helpData.user.name ?? "Text",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  helpData.user.email ?? "Email",
                  style: TextStyle(fontSize: 13, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 7,
        children: [
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text("Eventos"),
            onTap: () {
              //CloseNavigation
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => PageEventos()));
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.add_home_work),
            title: const Text("Tus Eventos"),
            onTap: () {
              //CloseNavigation
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PageAddEvento()));
            },
          ),
          const Divider(color: Colors.black54),
          ListTile(
            leading: const Icon(Icons.assignment_turned_in),
            title: const Text("Invitaciones"),
            onTap: () {
              //CloseNavigation
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PageInvitaciones()));
            },
          )
        ],
      ));
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:friendshift/models/user_model.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:friendshift/pages/page_edit_profile.dart';
import 'package:friendshift/pages/page_login.dart';
import 'package:friendshift/screens/profile_widget.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;
import '../screens/navigation_drawer.dart';

class PageUser extends StatefulWidget {
  const PageUser({Key? key}) : super(key: key);

  // final User user;
  //const PageUser({Key? key, required this.user}) : super(key: key);
  @override
  State<PageUser> createState() => _PageUserState();
}

class _PageUserState extends State<PageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        title: const Text("User"),
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: helpData.url1,
            onClicked: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                          user: helpData.user,
                        )),
              );
            },
          ),
          const SizedBox(height: 24),
          buildName(helpData.user),
          const SizedBox(height: 48),
          buildAbout(helpData.user),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name ?? "name",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email ?? "email",
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.description ?? "about",
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Text(
              'Register',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.registrationDate ?? "fecha",
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Cerrar Sesion"),
              onTap: () {
                //CloseNavigation

                User user = new User();
                helpData.user = user;
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => PageLogin()));
              },
            ),
          ],
        ),
      );
}

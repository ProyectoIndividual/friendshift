import 'dart:convert';
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friendshift/models/user_model.dart';
import 'package:friendshift/screens/navigation_drawer.dart';
import 'package:friendshift/screens/profile_widget.dart';
import 'package:friendshift/screens/textfield_widget.dart';
import 'package:friendshift/services/api_service.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late File image = new File('ok');
  late bool imageBool = false;
  late String newImgBase64 = "";
  User user = new User();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: const NavigationDrawer(),
        appBar: AppBar(
          title: const Text("Edit User"),
          backgroundColor: Colors.cyan,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          physics: const BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: imageBool == false ? helpData.url1 : image.path,
              isEdit: true,
              onClicked: () async {
                showImageSource(context);
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Full Name',
              text: user.name ?? "name",
              onChanged: (name) {
                user.name = name;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Email',
              text: user.email ?? "email",
              onChanged: (email) {
                user.email = email;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Phone',
              text: user.phone ?? "phone",
              onChanged: (phone) {
                user.phone = phone;
              },
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'About',
              text: user.description ?? "description",
              maxLines: 5,
              onChanged: (about) {
                user.description = about;
              },
            ),
            const SizedBox(height: 24),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  this.putUser(context);
                },
                child: Text(
                  'Edit',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      );

  void putUser(BuildContext context) async {
    if (newImgBase64 != null) {
      user.image = newImgBase64;
    }
    await ApiService().putUser(user);
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
      setState(() => imageBool = true);

      newImgBase64 = base64Encode(this.image.readAsBytesSync());
      //MyFirebaseData().saveImagePath(imageTemporary, context);
    } on PlatformException catch (e) {}
  }

  showImageSource(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text("Camara"),
                  onTap: () =>
                      Navigator.of(context).pop(pickImage(ImageSource.camera)),
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: Text("Galeria"),
                  onTap: () =>
                      Navigator.of(context).pop(pickImage(ImageSource.gallery)),
                ),
              ],
            ));
  }
}

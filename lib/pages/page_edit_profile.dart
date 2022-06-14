import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:friendshift/models/user_model.dart';
import 'package:friendshift/pages/page_user_info.dart';
import 'package:friendshift/screens/navigation_drawer.dart';
import 'package:friendshift/screens/profile_widget.dart';

import 'package:friendshift/services/api_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;

class EditProfilePage extends StatefulWidget {
  final User user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
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
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              TextFormField(
              decoration: new InputDecoration(
                  labelText: 'Name',
                  hintText: user.name,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide:
                    BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()),
              onFieldSubmitted: (value) {
                setState(() {
                  user.name = value.capitalize();
                  // firstNameList.add(firstName);
                });
              },
              onChanged: (value) {
                setState(() {
                  user.name = value.capitalize();
                });
              },
              ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Surnames',
                        hintText: user.surnames,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    onFieldSubmitted: (value) {
                      setState(() {
                        user.surnames = value.capitalize();
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        user.surnames = value.capitalize();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Email',
                        hintText: user.email,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    onFieldSubmitted: (value) {
                      setState(() {
                        user.email = value;
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        user.email = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'Phone',
                        hintText: user.phone,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (value) {
                      setState(() {
                        user.phone = value.capitalize();
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        user.phone = value.capitalize();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: new InputDecoration(
                        labelText: 'About',
                        hintText: user.description,

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    onFieldSubmitted: (value) {
                      setState(() {
                        user.description = value.capitalize();
                        // firstNameList.add(firstName);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        user.description = value.capitalize();
                      });
                    },
                  ),

                ],
              ),
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
    user=await ApiService().putUser(user);
    helpData.user=user;


    Fluttertoast.showToast(
      msg: "UsuarioActualizado!",
      toastLength: Toast.LENGTH_LONG,
      fontSize: 20,
      backgroundColor: Colors.cyan,
    );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PageUser()),
      );

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

extension StringExtension on String {
  // Method used for capitalizing the input from the form
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}


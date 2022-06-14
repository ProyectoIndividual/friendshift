import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friendshift/models/event_model.dart';
import 'package:friendshift/models/localitation_model.dart';
import 'package:friendshift/pages/page_add_eventos.dart';
import 'package:friendshift/pages/page_eventos.dart';
import 'package:friendshift/screens/navigation_drawer.dart';
import 'package:friendshift/screens/profile_widget.dart';
import 'package:friendshift/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;

class PageAddEventoForm extends StatefulWidget {
  const PageAddEventoForm({Key? key}) : super(key: key);

  State<PageAddEventoForm> createState() => _PageAddEventoFormState();
}

class _PageAddEventoFormState extends State<PageAddEventoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String street = "";
  String cityName = "";
  String details = "";
  String price = "0";
  bool isPublic = true;
  /*	"details":"FiestaAAAAAAAAAA",
	"startTimePlanned":"2022-06-17",
	"price":0,
	"isPublic":true,*/
  late File img;

  bool imageBool = false;
  String imgBase64 = "";

  _submit() {
    Localitation localitation = new Localitation();
    localitation.cityName = cityName;
    localitation.street = street;

    Event event = new Event();
    event.details = details;

    var f = new DateFormat('yyyy-MM-dd');
    var date = f.format(new DateTime.now()).toString();

    if (imgBase64 != "") {
      event.image = imgBase64;
    }else{
      event.image = helpData.base54Event;
    }
    event.startTimePlanned = date;
    event.price = double.parse(price);
    event.isPublic = isPublic;
    event.localitation = localitation;
    event.user = helpData.user;
    addEvent(event);
  }

  addEvent(Event event) async {
    Event event1 = new Event();
    event1 = await ApiService().postEvent(event);

    if (event1 != null) {
      Fluttertoast.showToast(
        msg: "Evento Añadido!",
        toastLength: Toast.LENGTH_LONG,
        fontSize: 20,
        backgroundColor: Colors.cyan,
      );
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PageEventos()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text("Form Evento"),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
      child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.topLeft,
                child: Text("Introduce los datos del Evento",
                    style: TextStyle(
                      fontSize: 24,
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              ProfileWidget(
                imagePath: imageBool == false ? helpData.url1 : img.path,
                isEdit: true,
                onClicked: () async {
                  showImageSource(context);
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'City',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                            BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      onFieldSubmitted: (value) {
                        setState(() {
                          cityName = value.capitalize();
                          // firstNameList.add(firstName);
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          cityName = value.capitalize();
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 3) {
                          return 'The city must contain at least 3 characters';
                        } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                          return 'The city cannot contain special characters';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Street',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                            BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 3) {
                          return 'Street must contain at least 3 characters';
                        } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                          return 'Street Name cannot contain special characters';
                        }
                      },
                      onFieldSubmitted: (value) {
                        setState(() {
                          street = value.capitalize();
                          // lastNameList.add(lastName);
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          street = value.capitalize();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Detalles',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                            BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 3) {
                          return 'Detalles must contain at least 3 characters';
                        } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                          return 'Detalles cannot contain special characters';
                        }
                      },
                      onFieldSubmitted: (value) {
                        setState(() {
                          details = value.capitalize();
                          // lastNameList.add(lastName);
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          details = value.capitalize();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Precio',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                            BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                          return 'Use only numbers!';
                        }
                      },
                      onFieldSubmitted: (value) {
                        setState(() {
                          price = value;

                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          price = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormField<bool>(
                      builder: (state) {
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                    value: isPublic,
                                    onChanged: (value) {
                                      setState(() {
                                        isPublic = value as bool;
                                        state.didChange(value);
                                      });
                                    }),
                                Text('Publico?'),
                              ],
                            ),
//display error in matching theme
                            Text(
                              state.errorText ?? '',
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                              ),
                            )
                          ],
                        );
                      },
//output from validation will be displayed in state.errorText (above)
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(25)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submit();
                        }
                      },
                      child: const Text("Add Event"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      ),
    )
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.img = imageTemporary);
      setState(() => imageBool = true);

      imgBase64 = base64Encode(this.img.readAsBytesSync());
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

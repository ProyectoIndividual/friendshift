import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:friendshift/models/event_model.dart';
import 'package:friendshift/models/invitation_model.dart';
import 'package:friendshift/models/user_model.dart';
import 'package:friendshift/pages/page_eventos.dart';
import 'package:friendshift/pages/page_invitaciones.dart';
import 'package:friendshift/screens/navigation_drawer.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;
import 'package:friendshift/services/api_service.dart';
import 'package:http/http.dart' as http;

class PageEventoInfo extends StatefulWidget {
  final Event evento;

  const PageEventoInfo({Key? key, required this.evento}) : super(key: key);

  @override
  _PageEventoInfoState createState() => _PageEventoInfoState();
}

class _PageEventoInfoState extends State<PageEventoInfo> {
  late Future<List<Invitation>> invitaciones = getAsistentes(widget.evento);
  late Invitation invitacionUser;

  bool invitado = false;
  bool userEvento = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userInvitado;

    invitaciones.then((value) {
      List<Invitation> listinvi = value;
      userInvitado =
          listinvi.where((element) => element.user?.id == helpData.user.id);

      if (userInvitado != null) {
        setState(() {
          invitado = true;
        });
      } else {
        invitacionUser = userInvitado;
      }
    });

    if (widget.evento.user?.name == helpData.user.name) {
      setState(() {
        userEvento = true;
      });
    }
  }

  static Future<List<Invitation>> getAsistentes(Event evento) async {
    print(evento.details);
    List<Invitation> invitaciones = [];

    invitaciones = await ApiService().getInvitationEvents(evento.id ?? 1);

    if (invitaciones.length >= 1 || invitaciones != null) {
      return invitaciones;
    } else {
      invitaciones = [];
      return invitaciones;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text("Evento"),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .35,
            padding: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            child: Image.network(helpData.url1),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 40, right: 14, left: 14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.evento.user!.name}  ${widget.evento.user!.surnames}",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              " Precio",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${widget.evento.price}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Publico",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.evento.isPublic == null ? "Si" : "No",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ciudad",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${widget.evento.localitation!.cityName}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Calle",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${widget.evento.localitation!.street}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${widget.evento.details}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Asistentes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 50,
                          child: FutureBuilder<List<Invitation>>(
                            future: invitaciones,
                            builder: (context, snapshot) {
                              if (snapshot.hasData && snapshot.data != null) {
                                final invitaciones = snapshot.data!;
                                return listaAsistentes(invitaciones);
                              }
                              return const Text("No Asistentes");
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 50,
                          width: 250,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: FlatButton(
                            onPressed: () {
                              this.addInvitacion();
                            },
                            child: Text(
                              invitado != true
                                  ? "Asistir"
                                  : "EliminarAsistencia",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        userEvento == true
                            ? Container(
                                height: 50,
                                width: 250,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: FlatButton(
                                  onPressed: () {
                                    this.dellEvento();
                                  },
                                  child: Text(
                                    "EliminarEvento",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                ),
                              )
                            : const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listaAsistentes(List<Invitation> invitaciones) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: invitaciones.length,
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(right: 6),
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(child: Text("${invitaciones[index].user!.name}")),
      ),
    );
  }

  Future<void> deleteInvitation() async {
    await ApiService().dellInvitation(invitacionUser);
  }

  Future<void> addInvitacion() async {
    Invitation invitation = new Invitation();
    invitation.totalAmount = widget.evento.price;
    //User usuario = new User();
    // usuario.id = helpData.user.id;
    invitation.user = helpData.user;
    invitation.event = widget.evento;
    if (widget.evento.isPublic != null || widget.evento.isPublic == "false") {
      invitation.accept = false;
    } else {
      invitation.accept = true;
    }

    test(invitation);

    /* invitation = await ApiService().postInvitation(invitation);

    if (invitation != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PageInvitaciones()),
      );
    }*/
  }

  Future<void> test(Invitation invitacion) async {
    var url = "http://localhost:9000/friendshift/";
    var uri = Uri.parse(url + "invitation");
    var header = {"Content-Type": "application/json"};
    var client = http.Client();

    var response =
        await client.post(uri, headers: header, body: jsonEncode(invitacion));

    print("Invi");
    print(response.body);
    Map<String, dynamic> invimap = jsonDecode(response.body);
    var invitation1 = Invitation.fromJson(invimap);

    print("Invi3 ${invitation1.id}");
    print("Invi3 ${invitation1.user!.name}");
    print("Invi 3${invitation1.event!.user!.name}");
    print("Invi3 ${invitation1.id}");
  }

  void dellEvento() async {
    await ApiService().dellEvento(widget.evento);

    Navigator.pop(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PageEventos()));
  }
}

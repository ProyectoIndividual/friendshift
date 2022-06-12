import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friendshift/pages/page_add_evento_form.dart';
import 'package:friendshift/screens/list_event.dart';
import 'package:image_picker/image_picker.dart';

import '../models/event_model.dart';
import '../screens/navigation_drawer.dart';
import '../services/api_service.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;

class PageAddEvento extends StatefulWidget {
  const PageAddEvento({Key? key}) : super(key: key);

  State<PageAddEvento> createState() => _PageAddEventoState();
}

class _PageAddEventoState extends State<PageAddEvento> {
  Future<List<Event>> events = getData();

  static Future<List<Event>> getData() async {
    final events = await ApiService().getEventsIdUser(helpData.user.id ?? 0);

    return events;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
          title: const Text("Tus Eventos"),
          backgroundColor: Colors.cyan,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: <Widget>[
                  Row(children: <Widget>[
                    const Text("Nuevo Evento",
                        style: TextStyle(
                          fontSize: 24,
                        )),
                    const Spacer(),
                    ElevatedButton(
                      child: const Icon(Icons.add_card),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const PageAddEventoForm()),
                        );
                      },
                    ),
                  ]),
                ]),
              ),
              Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: const Text("Tus eventos",
                      style: TextStyle(
                        fontSize: 24,
                      ))),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: FutureBuilder<List<Event>>(
                  future: events,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final events = snapshot.data!;
                      return ListEvents(events);
                    } else {
                      return const Text("No eventos");
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
/*
class PageAddEvento extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        
      );
}
*/
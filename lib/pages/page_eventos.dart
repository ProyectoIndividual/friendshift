import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:friendshift/models/event_model.dart';
import 'package:friendshift/screens/list_event.dart';
import 'package:friendshift/screens/navigation_drawer.dart';
import 'package:friendshift/services/api_service.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;

class PageEventos extends StatefulWidget {
  const PageEventos({Key? key}) : super(key: key);

  @override
  _PageEventoState createState() => _PageEventoState();
}

class _PageEventoState extends State<PageEventos> {
  Future<List<Event>> events = getData();
  late List<Event> eventName = [];

  TextEditingController cityController = new TextEditingController();
  var isLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  static Future<List<Event>> getData() async {
    final events = await ApiService().getEvents();

    return events;
  }

  Future<void> searchCity(String query) async {
    final eventsCity = await ApiService().getEventsCity(query);

    if (eventsCity != null) {
      setState(() {
        eventName = eventsCity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
          title: const Text("Eventos"),
          backgroundColor: Colors.cyan,
          actions: [],
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: TextField(
                controller: cityController,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Name city',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.cyan))),
                onChanged: searchCity,
              ),
            ),
            const SizedBox(height: 5),
            eventName.length == 0
                ? FutureBuilder<List<Event>>(
                    future: events,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final events = snapshot.data!;
                        return ListEvents(events);
                      } else {
                        return const Text("No eventos");
                      }
                    },
                  )
                : ListEvents(eventName)
          ],
        ));
  }

  Widget expandex(BuildContext context) => Expanded(
      child: ListView.builder(
          itemCount: eventName.length,
          itemBuilder: (context, index) {
            final ev = eventName[index];
            return ListTile(
              leading: Image.network(
                helpData.url1,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              title:
                  Text("${ev.localitation?.cityName}   BY: ${ev.user?.name}"),
            );
          }));
}

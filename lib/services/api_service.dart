import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:friendshift/models/event_model.dart';
import 'package:friendshift/models/invitation_model.dart';
import 'package:friendshift/models/localitation_model.dart';
import 'package:friendshift/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  var client = http.Client();
  var url = "http://localhost:9000/friendshift/";

  //Login
  Future<User> postLogin(User user) async {
    var uri = Uri.parse(this.url + "user/login");
    var header = {"Content-Type": "application/json"};
    var response =
        await this.client.post(uri, headers: header, body: jsonEncode(user));

    if (response.statusCode == 404) {
      return user;
    }

    var json = response.body;
    Map<String, dynamic> userMap = jsonDecode(json);
    var user1 = User.fromJson(userMap);

    return user1;
  }

  //Add localitation
  Future<Localitation> postLocalitation(Localitation? localitation) async {
    var uri = Uri.parse(this.url + "localitation");
    var header = {"Content-Type": "application/json"};
    var response = await this
        .client
        .post(uri, headers: header, body: jsonEncode(localitation));

    var json = response.body;
    Map<String, dynamic> localitationMap = jsonDecode(json);
    var localitation1 = Localitation.fromJson(localitationMap);
    return localitation1;
  }

  //Add user
  Future<User> postUser(User user) async {
    var uri = Uri.parse(this.url + "user");
    var header = {"Content-Type": "application/json"};

    var localitation = await postLocalitation(user.localitation);
    user.localitation = localitation;
    print("Loca");
    print(jsonDecode(jsonEncode(user.localitation)));

    var response =
        await client.post(uri, headers: header, body: jsonEncode(user));

    var json = response.body;
    Map<String, dynamic> userMap = jsonDecode(json);
    var user1 = User.fromJson(userMap);
    return user1;
  }

  //Edit user
  Future<User> putUser(User user) async {
    var uri = Uri.parse(this.url + "user/" + user.id.toString());
    var header = {"Content-Type": "application/json; charset=UTF-8"};

    var response =
        await client.put(uri, headers: header, body: jsonEncode(user));

    var json = response.body;
    Map<String, dynamic> userMap = jsonDecode(json);
    var user1 = User.fromJson(userMap);
    return user1;
  }

  //Get events
  Future<List<Event>> getEvents() async {
    var uri = Uri.parse(this.url + "event");
    var header = {"Content-Type": "application/json"};

    var response = await this.client.get(uri);

    Iterable list = jsonDecode(response.body);

    List<Event> events = list.map((e) => Event.fromJson(e)).toList();
    return events;
  }

  //Get events by cityName
  Future<List<Event>> getEventsCity(String city) async {
    var uri = Uri.parse(this.url + "event?search=localitation.city:" + city);
    var header = {"Content-Type": "application/json"};

    var response = await this.client.get(uri);

    Iterable list = jsonDecode(response.body);

    List<Event> events = list.map((e) => Event.fromJson(e)).toList();
    return events;
  }

  //GetEventsByID user
  Future<List<Event>> getEventsIdUser(int id) async {
    var uri = Uri.parse(this.url + "event?search=user.id:" + id.toString());
    var header = {"Content-Type": "application/json"};

    var response = await this.client.get(uri);

    Iterable list = jsonDecode(response.body);

    List<Event> events = list.map((e) => Event.fromJson(e)).toList();
    return events;
  }

  //Add evento
  Future<Event> postEvent(Event event) async {
    var uri = Uri.parse(this.url + "event");
    var header = {"Content-Type": "application/json"};

    var localitation = await postLocalitation(event.localitation);

    event.localitation = localitation;
    var response =
        await client.post(uri, headers: header, body: jsonEncode(event));

    if (response.statusCode == 404) {
      return event;
    }

    var json = response.body;
    Map<String, dynamic> eventMap = jsonDecode(json);
    var event1 = Event.fromJson(eventMap);

    return event1;
  }

  //GetInvitacionesEventos por event id
  Future<List<Invitation>> getInvitationEvents(int id) async {
    var uri =
        Uri.parse(this.url + "invitation?search=event.id:" + id.toString());
    var header = {"Content-Type": "application/json"};

    List<Invitation> invitations = [];
    var response = await this.client.get(uri);

    if (response.body.isNotEmpty) {
      Iterable list = jsonDecode(response.body);

      invitations = list.map((e) => Invitation.fromJson(e)).toList();
      return invitations;
    } else {
      return invitations;
    }
  }

  //GetInvitacionesUsuario por id user
  Future<List<Invitation>> getInvitationUser(int id) async {
    var uri =
        Uri.parse(this.url + "invitation?search=user.id:" + id.toString());
    var header = {"Content-Type": "application/json"};

    var response = await this.client.get(uri);

    Iterable list = jsonDecode(response.body);

    List<Invitation> invitations =
        list.map((e) => Invitation.fromJson(e)).toList();
    return invitations;
  }

  //Add invitacion
  Future<Invitation> postInvitation(Invitation invitation) async {
    var uri = Uri.parse(this.url + "invitation");
    var header = {"Content-Type": "application/json"};

    var response = await this
        .client
        .post(uri, headers: header, body: jsonEncode(invitation));

    Map<String, dynamic> invimap = jsonDecode(response.body);
    var invitation1 = Invitation.fromJson(invimap);
    return invitation1;
  }

  //Eliminar invitacion
  Future<void> dellInvitation(Invitation invitation) async {
    var uri = Uri.parse(this.url + "invitation/" + invitation.id.toString());
    var header = {"Content-Type": "application/json"};

    var response = await this.client.delete(uri);
  }

  //Eliminar Evento
  Future<void> dellEvento(Event evento) async {
    var uri = Uri.parse(this.url + "event/" + evento.id.toString());
    var header = {"Content-Type": "application/json"};

    var response = await this.client.delete(uri);
  }
}

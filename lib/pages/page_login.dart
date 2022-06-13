import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:friendshift/models/user_model.dart';
import 'package:friendshift/pages/page_eventos.dart';
import 'package:friendshift/pages/page_register.dart';
import 'package:friendshift/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../screens/navigation_drawer.dart';
import 'package:friendshift/help/helpdata.dart' as helpData;
import 'package:path/path.dart';
import 'package:localstore/localstore.dart';

class PageLogin extends StatelessWidget {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  PageLogin({Key? key}) : super(key: key);

  getLogin(context) async {
    User user = new User();

    user.email = emailController.text;
    user.password = passwordController.text;

    user = await ApiService().postLogin(user);

    if (user.id != null) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("user", jsonEncode(user));
      helpData.user = user;

      final db = Localstore.instance;
      // gets new id
      final userStorage = db.collection('user').doc().id;
      db.collection("user").doc(userStorage).set(user.toJson());

      //print("Login${helpData.user.localitation?.cityName}");
      // print(user.surnames);
      Fluttertoast.showToast(
        msg: "Login OK!",
        toastLength: Toast.LENGTH_LONG,
        fontSize: 20,
        backgroundColor: Colors.cyan,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PageEventos()),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Contraseña o Usuario Incorrectas",
        toastLength: Toast.LENGTH_LONG,
        fontSize: 20,
        backgroundColor: Colors.cyan,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PageLogin()),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          backgroundColor: Colors.cyan,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Container(
                      width: 350,
                      height: 300,

                      /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.network('assets/logoProyecto.png')),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () {
                    this.getLogin(context);
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 130,
              ),
              InkWell(
                child: Text('New User? Create Account'),
                onTap: () {
                  print("value of your text");
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PageRegister()));
                },
              )
            ],
          ),
        ),
      );
}

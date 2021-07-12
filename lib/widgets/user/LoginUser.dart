import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:http/http.dart' as http;


class LoginUser extends StatefulWidget {
  final LocalStorage storage;
  final Function callback;
  LoginUser(this.storage, this.callback);


  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _formKey = GlobalKey<FormState>();
  final emialController = TextEditingController();
  final passwordController  = TextEditingController();

  void setUsernameStorage(value) {
    widget.storage.setItem("username", {"username": jsonDecode(value.body)['username']});
    widget.callback();
  }

  void setError(context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect email/contraseña', style: TextStyle(color: Colors.red, fontSize: 23))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1a1414),
          iconTheme: IconThemeData(color: Color(0xffd5f971)),
          title: const Text('Inicia sesion', style: TextStyle(color: Color(0xffd5f971))),
        ),
        backgroundColor: Color(0xff1a1414),
        body: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(fontSize: 18, color: Color(0xffd5f971)),
                  controller: emialController,
                  decoration: const InputDecoration(
                    hintText: 'Introduci tu email',
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Color(0xffec1fa2)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value)) {
                      return 'Email invalido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  style: TextStyle(fontSize: 18, color: Color(0xffd5f971)),
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Introduci tu contraseña',
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: Color(0xffec1fa2)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Contraseña incorrecta';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        var body =  json.encode({"email":  emialController.text,
                                                "password": passwordController.text });
                        final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "user/login"),
                            headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                            body: body);
                        _response.then((value) => {
                          value.statusCode == 200 ? this.setUsernameStorage(value)  : this.setError(context)
                        });

                      }
                    },
                    child: Text('Submit', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

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
          title: const Text('Inicia sesion'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: emialController,
                  decoration: const InputDecoration(
                    hintText: 'Introduci tu email',
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value)) {
                      return 'Email invalido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Introduci tu contraseña',
                    labelText: 'Contraseña',
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
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

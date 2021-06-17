import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:http/http.dart' as http;

class RegisterUser extends StatefulWidget {
  final LocalStorage storage;
  RegisterUser(this.storage);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  RegExp emailValidatorRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final emialController = TextEditingController();
  final passwordController  = TextEditingController();
  final usernameController  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea tu cuenta o inicia sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Form(
          key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Introduci tu nombre de usuario',
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor un usuario';
                      }
                      return null;
                    },
                  ),
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
                      if (value == null || value.isEmpty || value.length < 5) {
                        return 'Por favor introduci una contraseña mas segura';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                            var body =  json.encode({"username": usernameController.text,
                                                    "email":  emialController.text,
                                                    "password": passwordController.text });
                        final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "user/create"),
                                                    headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                                                    body: body);

                        _response.then((value) => {
                            widget.storage.setItem("username", {"username": jsonDecode(value.body)['username']}),
                            Navigator.pop(context)
                        });

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
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

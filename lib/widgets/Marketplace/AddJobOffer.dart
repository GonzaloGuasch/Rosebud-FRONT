import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;

import 'Marketplace.dart';

class NewJobOfferForm extends StatefulWidget {
  final String usernameCreator;
  final LocalStorage localStorage;
  NewJobOfferForm(this.usernameCreator, this.localStorage);

  @override
  _NewJobOfferFormState createState() => _NewJobOfferFormState();
}

class _NewJobOfferFormState extends State<NewJobOfferForm> {
  final List<Map<String, dynamic>> _locationItems = [
    {
      'value': 'buenosAires',
      'label': 'Buenos aires',
    },
    {
      'value': 'cordoba',
      'label': 'Cordoba',
    },
    {
      'value': 'Chacho',
      'label': 'Chacho',
    },
    {
      'value': 'laPampa',
      'label': 'La Pampa',
    },
    {
      'value': 'entreRios',
      'label': 'Entre Rios',
    },
    {
      'value': 'santaFe',
      'label': 'Sante Fe',
    },
    {
      'value': 'Quilmes',
      'label': 'Quilmes',
    },
  ];
  final List<Map<String, dynamic>> _durationItems = [
    {
      'value': '1',
      'label': '1 semana',
    },
    {
      'value': '2',
      'label': '2 semana',
    },
    {
      'value': '3',
      'label': '3 semana',
    },
    {
      'value': '4',
      'label': '4 semana',
    },
    {
      'value': '4',
      'label': '4 semana',
    },
    {
      'value': '5',
      'label': '5 semana',
    },
    {
      'value': '6',
      'label': '6 semana',
    },
    {
      'value': '7',
      'label': '7 semana',
    },
    {
      'value': '8',
      'label': '8 semana',
    },
    {
      'value': '9',
      'label': '9 semana',
    },
    {
      'value': '10',
      'label': '10 semana',
    },
    {
      'value': '11',
      'label': '11 semana',
    },
    {
      'value': '12',
      'label': '12 semana',
    },


  ];
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'NoRemunerada',
      'label': 'No remunerada',
    },
    {
      'value': 'PagoSegunGanancias',
      'label': 'Pago segun ganancias',
      'textStyle': TextStyle(color: Colors.red),
    },
    {
      'value': 'PagoFijo',
      'label': 'Pago fijo',

    },
    {
      'value': 'PagoConReel',
      'label': 'Pago con reel',
    },
  ];
  final _formKey = GlobalKey<FormState>();
  final tituloTextController = TextEditingController();
  final descripcionTextController = TextEditingController();
  final locacionTextController = TextEditingController();
  final selectTextController = TextEditingController();
  final durationTextController = TextEditingController();
  String category = 'Peliculas';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1a1414),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Color(0xffd5f971)),
          backgroundColor: Color(0xff1a1414),
          title: Text("Agrega tu nueva propuesta!", style: TextStyle(color: Color(0xffd5f971))),
        ),
        body: ListView(
          children: [Form(
            key: _formKey,
            child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(fontSize: 18, color: Color(0xffd5f971)),
                    controller: tituloTextController,
                    decoration: const InputDecoration(
                      hintText: 'Busca un titulo llamativo',
                      labelText: 'Titulo oferta',
                      labelStyle: TextStyle(color: Color(0xffec1fa2)),
                    ),
                    // ignore: missing_return
                    validator: (value) { if (value == null || value.isEmpty) { return 'No dejes el campo vacio'; }
                    },
                  ),
                  TextFormField(
                    maxLines: 2,
                    style: TextStyle(fontSize: 18, color: Color(0xffd5f971)),
                    controller: descripcionTextController,
                    decoration: const InputDecoration(
                      hintText: 'Ponele una descripcion copada',
                      labelText: 'Descripcion oferta',
                      labelStyle: TextStyle(color: Color(0xffec1fa2)),
                    ),
                    // ignore: missing_return
                    validator: (value) { if (value == null || value.isEmpty) { return 'No dejes el campo vacio'; }
                    },
                  ),
                  SelectFormField(
                      style: TextStyle(fontSize: 18, color: Color(0xffd5f971)),
                      controller: durationTextController,
                      type: SelectFormFieldType.dropdown,
                      items: _durationItems,
                      labelText: 'Duracion en semanas',
                      // ignore: missing_return
                      validator: (value) { if (value == null || value.isEmpty) { return 'Falta elegir la duracion'; } }
                  ),
                  SelectFormField(
                      style: TextStyle(fontSize: 18, color: Color(0xffd5f971)),
                      controller: locacionTextController,
                      type: SelectFormFieldType.dropdown,
                      items: _locationItems,
                      labelText: 'Locacion de propuesta',
                      // ignore: missing_return
                      validator: (value) { if (value == null || value.isEmpty) { return 'Falta elegir la locacion'; } }
                  ),
                  SelectFormField(
                    style: TextStyle(fontSize: 18, color: Color(0xffd5f971)),
                    controller: selectTextController,
                    type: SelectFormFieldType.dropdown,
                    items: _items,
                    labelText: 'Tipo de remuneracion',
                    onChanged: (val) => print(val),
                    onSaved: (val) => print(val),
                    // ignore: missing_return
                    validator: (value) { if (value == null || value.isEmpty) { return 'Falta elegir la remuneracion'; } }
                  ),
                DropdownButton<String>(
                  value: this.category,
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newCategorySelected) {
                    setState(() {
                      this.category = newCategorySelected;
                    });
                  },
                  items: <String>['Musica', 'Peliculas'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "jobOffer/create"),
                                                    headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                                                    body:  json.encode({'userAuthor': widget.usernameCreator,
                                                                        'description': descripcionTextController.text,
                                                                        'title': tituloTextController.text,
                                                                        'remuneration': selectTextController.text,
                                                                        'location': locacionTextController.text,
                                                                        'durationInWeeks': durationTextController.text,
                                                                        'category': this.category}));
                        _response.then((v) => {
                            Navigator.push(
                            context,
                              MaterialPageRoute(builder: (context) => MarketPlace(widget.localStorage)),
                            )
                        });
                      }
                    },
                    child: Text('Submit'),
                  ),
            ],
          ),
        )])
    );
    }
}

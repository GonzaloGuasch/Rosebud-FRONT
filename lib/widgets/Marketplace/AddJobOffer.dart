import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/utils/utils.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;

class NewJobOfferForm extends StatefulWidget {
  @override
  _NewJobOfferFormState createState() => _NewJobOfferFormState();
}

class _NewJobOfferFormState extends State<NewJobOfferForm> {
  final _formKey = GlobalKey<FormState>();
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
      'icon': Icon(Icons.stop),
    },
    {
      'value': 'PagoSegunGanancias',
      'label': 'Pago segun ganancias',
      'icon': Icon(Icons.fiber_manual_record),
      'textStyle': TextStyle(color: Colors.red),
    },
    {
      'value': 'PagoFijo',
      'label': 'Pago fijo',
      'icon': Icon(Icons.grade),
    },
    {
      'value': 'PagoConReel',
      'label': 'Pago con reel',
      'icon': Icon(Icons.grade),
    },
  ];

  final tituloTextController = TextEditingController();
  final descripcionTextController = TextEditingController();
  final locacionTextController = TextEditingController();
  final selectTextController = TextEditingController();
  final durationTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 55.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 350),
                child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              TextFormField(
                controller: tituloTextController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Ponele un titulo copado',
                  labelText: 'Titulo oferta',
                ),
                // ignore: missing_return
                validator: (value) { if (value == null || value.isEmpty) { return 'No dejes el campo vacio'; }
                },
              ),
              TextFormField(
                maxLines: 2,
                controller: descripcionTextController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Ponele una descripcion copada',
                  labelText: 'Descripcion oferta',
                ),
                // ignore: missing_return
                validator: (value) { if (value == null || value.isEmpty) { return 'No dejes el campo vacio'; }
                },
              ),
              SelectFormField(
                  controller: durationTextController,
                  type: SelectFormFieldType.dropdown,
                  items: _durationItems,
                  icon: Icon(Icons.person),
                  labelText: 'Duracion en semanas',
                  // ignore: missing_return
                  validator: (value) { if (value == null || value.isEmpty) { return 'Falta elegir la duracion'; } }
              ),
              SelectFormField(
                  controller: locacionTextController,
                  type: SelectFormFieldType.dropdown,
                  items: _locationItems,
                  icon: Icon(Icons.person),
                  labelText: 'Locacion de propuesta',
                  // ignore: missing_return
                  validator: (value) { if (value == null || value.isEmpty) { return 'Falta elegir la locacion'; } }
              ),
              SelectFormField(
                controller: selectTextController,
                type: SelectFormFieldType.dropdown,
                items: _items,
                icon: Icon(Icons.person),
                labelText: 'Tipo de remuneracion',
                onChanged: (val) => print(val),
                onSaved: (val) => print(val),
                // ignore: missing_return
                validator: (value) { if (value == null || value.isEmpty) { return 'Falta elegir la remuneracion'; } }
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "jobOffer/create"),
                                                headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                                                body:  json.encode({'userAuthor': 'user_cuatro',
                                                                    'description': descripcionTextController.text,
                                                                    'title': tituloTextController.text,
                                                                    'remuneration': selectTextController.text,
                                                                    'location': locacionTextController.text,
                                                                    'durationInWeeks': durationTextController.text,
                                                                    'linkReference': 'asdasd'}));
                    _response.then((v) => {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: DialogoUploadOffer()))});
                  }
                  //todo
                  //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: DialogUploadOfferError()));
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      )
    );
    }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:http/http.dart' as http;

class NewJobOfferForm extends StatefulWidget {
  @override
  _NewJobOfferFormState createState() => _NewJobOfferFormState();
}

class _NewJobOfferFormState extends State<NewJobOfferForm> {
  final _formKey = GlobalKey<FormState>();

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 55.0),
          child: Column(
            children: [
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
              TextFormField(
                controller: locacionTextController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Locacion pensada del proyecto',
                  labelText: 'locacion',
                ),
                // ignore: missing_return
                validator: (value) { if (value == null || value.isEmpty) { return 'No dejes el campo vacio'; }
                },
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "jobOffer/create"),
                                                headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                                                body:  json.encode({'userAuthor': 'usuario',
                                                                    'description': descripcionTextController.text,
                                                                    'title': tituloTextController.text,
                                                                    'remuneration': selectTextController.text,
                                                                    'location': locacionTextController.text,
                                                                    'durationInWeeks': 10,
                                                                    'linkReference': 'asdasd'}));
                    return;
                  }
                  return;
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

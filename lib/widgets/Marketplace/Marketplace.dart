import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/data_model/JobOffer.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';
import 'package:select_form_field/select_form_field.dart';


import '../Home.dart';
import 'AddJobOffer.dart';
import 'JobOffer.dart';

class MarketPlace extends StatefulWidget {

  @override
  _MarketPlaceState createState() => _MarketPlaceState();
}

class _MarketPlaceState extends State<MarketPlace> {
  List<Widget> jobsOffer = [];

  @override
  void initState() {
    super.initState();
    final _jobOfferData = http.get(Uri.http(BACKEND_PATH_LOCAL, "jobOffer/all/"));
    _jobOfferData.then((value) => {
      //todo REFACTOR
      this.updateJobsOffer(List<JobOffer>.from(jsonDecode(value.body).map((aJobOfferJson) => JobOffer.fromJson(aJobOfferJson))))
    });
  }

   void updateJobsOffer(List<JobOffer> jobsOffers) {
    List<Widget> newJobsOffer = [];
    for(int i = 0; i < jobsOffers.length; i++) {
        Widget offer = JobOfferCard(jobsOffers[i]);
        newJobsOffer.add(offer);
    }
    if (!mounted) return;
    setState(() {
      this.jobsOffer = newJobsOffer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          MarketplaceFilters(updateJobsOffer),
          Column(
            children: this.jobsOffer,
          )
        ],
      )
    );
  }
}

class MarketplaceFilters extends StatefulWidget {
  final Function updateJobsOffer;
  MarketplaceFilters(this.updateJobsOffer);

  @override
  _MarketplaceFiltersState createState() => _MarketplaceFiltersState(updateJobsOffer);
}

class _MarketplaceFiltersState extends State<MarketplaceFilters> {
  final Function updateJobsOffer;
  var locationFilter = '';
  var remuneracionFilter = '';
  var isPaid = false;
  var duration = 0;
  _MarketplaceFiltersState(this.updateJobsOffer);


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

  final List<Map<String, dynamic>> _remuneracion = [
    {
      'value': 'NoRemunerada',
      'label': 'No remunerada',
    },
    {
      'value': 'PagoSegunGanancias',
      'label': 'Pago segun ganancias',
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


  Function updateLocationState(String newState) {
    setState(() {
        this.locationFilter = newState;
    });
  }
  Function updateRemuneracionState(String newRemuneracion) {
    setState(() {
      this.remuneracionFilter = newRemuneracion;
    });
  }
  void updateOffers(Object body) {
    List<JobOffer> jo = List<JobOffer>.from(jsonDecode(body).map((aJobOfferJson) => JobOffer.fromJson(aJobOfferJson)));
    this.updateJobsOffer(jo);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 300),
            child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeChoice())
                  );
                }),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Filter('Locacion', _locationItems, updateLocationState),
              Filter('Remuneracion', _remuneracion, updateRemuneracionState),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: IconButton(
                    icon:  Icon(Icons.add_rounded),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewJobOfferForm()),
                      );
                    }),
              ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
            padding: const EdgeInsets.all(13.0),
            backgroundColor: Colors.teal,
            primary: Colors.white,
            textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              final _response = http.get(Uri.http(BACKEND_PATH_LOCAL, "jobOffer/applyfilter/${this.locationFilter}/${this.remuneracionFilter}"),
                                    headers: { 'Content-type': 'application/json', 'Accept': 'application/json'});
              _response.then((value) =>  this.updateOffers(value.body));
            },
            child: const Text('Aplicar filtros'),
          ),
        ]
    );
  }
}

class Filter extends StatefulWidget {
  final String filterName;
  final List<Map<String, dynamic>> tipoSelect;
  final Function  callbackFunction;
  const Filter(this.filterName, this.tipoSelect, this.callbackFunction, {Key key}) : super(key : key);

  @override
  _FilterState createState() => _FilterState(this.filterName, this.tipoSelect, this.callbackFunction);
}

class _FilterState extends State<Filter> {
  final String filterName;
  final List<Map<String, dynamic>> tipoSelect;
  final Function  callbackFunction;
  _FilterState(this.filterName, this.tipoSelect, this.callbackFunction);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 150.0,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: SelectFormField(
              type: SelectFormFieldType.dropdown,
              labelText: this.filterName,
              items: this.tipoSelect,
              onChanged: (val) => this.callbackFunction(val),
          ),
        ),
      ),
    );
  }
}

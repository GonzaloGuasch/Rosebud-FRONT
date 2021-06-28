import 'dart:convert';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/data_model/JobOffer.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:rosebud_front/widgets/profile/userProfile.dart';

import '../Home.dart';
import 'AddJobOffer.dart';
import 'JobOffer.dart';

class MarketPlace extends StatefulWidget {
  final LocalStorage storage;
  MarketPlace(this.storage);

  @override
  _MarketPlaceState createState() => _MarketPlaceState();

}

class _MarketPlaceState extends State<MarketPlace> {
  List<Widget> jobsOffer = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context,
          <String>[
            "ofertas",
            "filtros",
            "agregarOferta",
          ]
      );
    });
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

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.storage.getItem('username') != null ?
     Container(
      color: Color(0xff181b20),
      child: ListView(
        children: [
        DescribedFeatureOverlay(
        featureId: 'filtros',
        targetColor: Colors.white,
        textColor: Colors.black,
        backgroundColor: Colors.red.shade300,
        contentLocation: ContentLocation.above,
        title: Text('Filtros de trabajo', style: TextStyle(fontSize: 20.0)),
        pulseDuration: Duration(seconds: 1),
        enablePulsingAnimation: true,
        barrierDismissible: false,
        overflowMode: OverflowMode.wrapBackground,
        openDuration: Duration(seconds: 1),
        description: Text('Buscar por locacion y tipo de remunaración en el trabajo que estes buscando!'),
        tapTarget: Icon(Icons.movie),
        child: MarketplaceFilters(updateJobsOffer, widget.storage)),
        DescribedFeatureOverlay(
          featureId: 'ofertas',
          targetColor: Colors.white,
          textColor: Colors.black,
          backgroundColor: Colors.amber.shade200,
          contentLocation: ContentLocation.trivial,
          title: Text('Busca la oferta que mas te convenza', style: TextStyle(fontSize: 20.0)),
          pulseDuration: Duration(seconds: 1),
          enablePulsingAnimation: true,
          barrierDismissible: false,
          overflowMode: OverflowMode.wrapBackground,
          openDuration: Duration(seconds: 1),
          description: Text("¿Sos artista amateur? Tenemos propuestas de estudiantes \n si buscas un trabajo formal también hay proyectos que apuntan a festivales. \n Recorda que se buscan actores/actrices, directoras/es, editores/as. Siempre viene bien una mano extra ;) "),
          tapTarget: Icon(Icons.work),
          child: Column(
              children: this.jobsOffer,
          ))
        ],
      )
    ) : RegisterUserProfile(widget.storage);
  }
}

class MarketplaceFilters extends StatefulWidget {
  final Function updateJobsOffer;
  final LocalStorage storage;
  MarketplaceFilters(this.updateJobsOffer, this.storage);

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
    return Container(
        child: Column(
          children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, right: 100),
                child: Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeChoice(widget.storage))
                          );
                        }),
                    Text("Ofertas de trabajo", style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ],
                )
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Filter('Locacion', _locationItems, updateLocationState),
                  Filter('Remuneracion', _remuneracion, updateRemuneracionState),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: DescribedFeatureOverlay(
                            featureId: 'agregarOferta',
                            targetColor: Colors.white,
                            textColor: Colors.white,
                            backgroundColor: Colors.blue,
                            contentLocation: ContentLocation.below,
                            title: Text('También podes publicar vos TU oferta!',
                            style: TextStyle(fontSize: 20.0),
                            ),
                            pulseDuration: Duration(seconds: 1),
                            enablePulsingAnimation: true,
                            overflowMode: OverflowMode.clipContent,
                            openDuration: Duration(seconds: 1),
                            description: Text('¿Estas buscando un equipo de trabajo para tu proyecto? \n publica tu oferta con una descripción copada, siempre hay gente dispuesta para trabajar!'),
                            tapTarget: Icon(Icons.add),
                            child: IconButton(
                              icon:  Icon(Icons.add_rounded),
                              onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NewJobOfferForm()),
                                  );
                              }),
                  )),
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
      ),
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

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/data_model/JobOffer.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/constants/constants.dart';

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
          MarketplaceFilters(),
          Column(
            children: this.jobsOffer,
          )
        ],
      )
    );
  }
}



class AddJobOffer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class MarketplaceFilters extends StatefulWidget {
  @override
  _MarketplaceFiltersState createState() => _MarketplaceFiltersState();
}

class _MarketplaceFiltersState extends State<MarketplaceFilters> {
  var locationFilter = '';
  var isPaid = false;
  var duration = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Filter('Locacion'),
          Filter('Duracion'),
          Filter('Duracion'),
          Padding(
            padding: const EdgeInsets.only(top: 70.0),
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
      );
  }
}

class Filter extends StatefulWidget {
  final String filterName;
  const Filter(this.filterName, {Key key}) : super(key : key);

  @override
  _FilterState createState() => _FilterState(this.filterName);
}

class _FilterState extends State<Filter> {
  final String filterName;
  _FilterState(this.filterName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 100.0,
        child: Padding(
          padding: const EdgeInsets.only(top: 65.0, left: 10.0),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: this.filterName,
            ),
          ),
        ),
      ),
    );
  }
}

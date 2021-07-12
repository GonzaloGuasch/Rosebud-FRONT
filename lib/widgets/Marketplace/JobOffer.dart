import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/JobOffer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Marketplace.dart';

class JobOfferCard extends StatelessWidget {
  JobOffer offer;
  LocalStorage localStorage;
  JobOfferCard(this.offer, this.localStorage);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
        context,
          MaterialPageRoute(builder: (context) => JobOfferScreem(this.offer, this.localStorage.getItem("username")["username"], this.offer.userApplied(this.localStorage.getItem("username")["username"]), this.localStorage)),
        );
      },
      child: this.offer.userApplied(this.localStorage.getItem("username")["username"]) ?  userApplied() : userDoestApply()
    );
  }

  Container userDoestApply() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: EdgeInsets.only(top: 10.0, bottom: 20.0), height: 140.0, width: 312.0,
      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff444548)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(this.offer.title.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0)),
          Text(this.offer.description, style: TextStyle(color: Color(0xff6a6d6f), fontSize: 15.0)),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text("Tipo de pago: ${this.offer.remuneration}", style: TextStyle(color: Colors.white, fontSize: 15.0)),
          )
        ],
      )
    );
  }
  Container userApplied() {
    return Container(
        padding: const EdgeInsets.all(10.0),
        margin: EdgeInsets.only(top: 10.0, bottom: 20.0), height: 140.0, width: 312.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff444548),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffd5f971).withOpacity(1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3))
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(this.offer.title.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0)),
            Text(this.offer.description, style: TextStyle(color: Color(0xff6a6d6f), fontSize: 15.0)),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text("Tipo de pago: ${this.offer.remuneration}", style: TextStyle(color: Colors.white, fontSize: 15.0)),
            )
          ],
        )
    );
  }
}


class JobOfferScreem extends StatefulWidget {
  final JobOffer jobOffer;
  final String username;
  final bool userApplied;
  final LocalStorage storage;
  const JobOfferScreem(this.jobOffer, this.username, this.userApplied, this.storage, {Key key}) : super(key: key);
  @override
  _JobOfferScreemState createState() => _JobOfferScreemState(jobOffer);
}

class _JobOfferScreemState extends State<JobOfferScreem> {
  JobOffer jobOffer;
  _JobOfferScreemState(this.jobOffer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xffd5f971)),
        backgroundColor: Color(0xff1a1414),
        title: Text("Oferta de trabajo", style: TextStyle(color: Color(0xffd5f971))),
      ),
      backgroundColor: Color(0xff181b20),
      body: widget.userApplied ? Padding(padding: const EdgeInsets.only(left: 12),
                                         child: Text("Ya aplicaste a la oferta!",
                                         style: TextStyle(fontSize: 35, color: Color(0xffec1fa2)))) : ofertaTrabajo(),
    );
  }

  Padding ofertaTrabajo() {
    return Padding(
      padding: const EdgeInsets.only(top: 45.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(this.jobOffer.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.white)),
          Text(this.jobOffer.description, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white60)),
          Text(this.jobOffer.userAuthor, style: TextStyle(fontSize: 16.0)),
          Text("Esta propuesta se va a llegar a cabo principalmente en: ${this.jobOffer.location}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white60)),
          Text("La duracion puede variar pero calculamos que minimante va a ser de ${this.jobOffer.durationInWeeks} semanas", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white60)),
          Text("Si te interesa entremos en contacto!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Colors.white60)),
          FloatingActionButton(
          onPressed: () {
            final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "jobOffer/addUsersInterested/${this.jobOffer.id}"),
                                        headers: { 'Content-type': 'application/json',
                                                   'Accept': 'application/json'},
                                        body: json.encode({ "usernameAuthor": this.jobOffer.userAuthor,
                                                            "title": this.jobOffer.title,
                                                            "username": widget.username}));
            _response.then((value) => {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MarketPlace(widget.storage))),
            });
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          child: const Icon(Icons.email),
          backgroundColor: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }
}


class JobOfferNoResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        margin: EdgeInsets.only(top: 10.0, bottom: 20.0), height: 140.0, width: 312.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff444548)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("No hay ofertas con esos filtros :c", style: TextStyle(color: Color(0xffd5f971), fontSize: 30)),
          ],
        )
    );
  }
}

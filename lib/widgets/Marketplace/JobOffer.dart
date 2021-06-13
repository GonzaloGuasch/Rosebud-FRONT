import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/JobOffer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobOfferCard extends StatelessWidget {
  JobOffer offer;
  JobOfferCard(this.offer);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
        context,
          MaterialPageRoute(builder: (context) => JobOfferScreem(this.offer)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: EdgeInsets.only(top: 10.0, bottom: 20.0), height: 140.0, width: 312.0,
        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff444548)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(this.offer.title.toString(), style: TextStyle(color: Colors.white, fontSize: 20.0)),
            Text(this.offer.description, style: TextStyle(color: Color(0xff6a6d6f), fontSize: 15.0)),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(this.offer.remuneration, style: TextStyle(color: Colors.white, fontSize: 15.0)),
            )
          ],
        )
      )
    );
  }
}


class JobOfferScreem extends StatefulWidget {
  final JobOffer jobOffer;
  const JobOfferScreem(this.jobOffer, {Key key}) : super(key: key);
  @override
  _JobOfferScreemState createState() => _JobOfferScreemState(jobOffer);
}

class _JobOfferScreemState extends State<JobOfferScreem> {
  JobOffer jobOffer;
  _JobOfferScreemState(this.jobOffer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff181b20),
      body: Padding(
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
              final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "email/sendEmail"),
                                          headers: { 'Content-type': 'application/json',
                                                     'Accept': 'application/json'},
                                          body: json.encode({ "setTo": "gonzaloguasch98@gmail.com",
                                                              "username": "gonzi" }));
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            child: const Icon(Icons.email),
            backgroundColor: Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }
}

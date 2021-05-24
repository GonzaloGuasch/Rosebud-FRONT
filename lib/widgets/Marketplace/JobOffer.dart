import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rosebud_front/data_model/JobOffer.dart';

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
        margin: EdgeInsets.only(top: 10.0, bottom: 20.0), height: 100.0, width: 312.0,
        decoration: BoxDecoration(border: Border.all()),
        child: Text(this.offer.title.toString()  + "\n" + this.offer.description),
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
      body: Padding(
        padding: const EdgeInsets.only(top: 65.0, left: 20.0),
        child: Column(
          children: [
            Text(this.jobOffer.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
            Text(this.jobOffer.description, style: TextStyle(fontSize: 22.0)),
            Text(this.jobOffer.userAuthor, style: TextStyle(fontSize: 16.0)),
            Text("Esta propuesta se va a llegar a cabo principalmente en: ${this.jobOffer.location}", style: TextStyle(fontSize: 18.0)),
            Text("La duracion puede variar pero calculamos que minimante va a ser de ${this.jobOffer.durationInWeeks} semanas" , style: TextStyle(fontSize: 18.0)),
            FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: const Icon(Icons.navigation),
            backgroundColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

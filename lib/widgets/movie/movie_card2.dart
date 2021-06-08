import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rosebud_front/widgets/review/review.dart';
import 'package:http/http.dart' as http;


class MovieScreem extends StatefulWidget {
  final Movie movie;
  const MovieScreem(this.movie, {Key key}) : super(key : key);

  @override
  _MovieScreemState createState() => _MovieScreemState(movie);
}

class _MovieScreemState extends State<MovieScreem> {
  Movie movie;
  bool isInList = false;
  _MovieScreemState(this.movie);
  TextEditingController  _controller = new TextEditingController(text: '');


  void initialState() async {
    final _movieData = await http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/getByTitle/" + this.movie.title));
    final _isInList = await http.get(Uri.http(BACKEND_PATH_LOCAL, "user/isMovieInList/" + this.movie.title + "/usuario"));
      setState(()  {
        this.movie = Movie.fromJson(jsonDecode(_movieData.body));
        this.isInList = jsonDecode(_isInList.body);
      });
  }

  void rateMovie(rating) {
    final rate = rating.toInt();
    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/rate"),
                      headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                      body:  json.encode({'movieTitle': this.movie.title, 'rate': rate.toString()}));
    _response.then((value) => {
      setState(() {
        this.movie = Movie.fromJson(jsonDecode(value.body));
      })
    });
  }

  void leaveReview(review, {hasSpoilers=false}) async {
    //todo ACA VA EL USUARIO LOGEADO
    final _response = await http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/leaveReview/"),
                            headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                            body: json.encode({"elementTitle": this.movie.title, "username": 'usuario', "review": review, "hasSpoilers": hasSpoilers}));
    if(_response.statusCode == 200) {
      //todo llevarme la 59-60 a una funcion para no repirme con redraw()
      this.reDraw();
    }
  }
  void reDraw() async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/getByTitle/" + this.movie.title));
    if(_response.statusCode == 200) {
      var movieResultJSON = jsonDecode(_response.body);
      var movieUpdate = Movie.fromJson(movieResultJSON);
      setState(()  {
        this.movie = movieUpdate;
      });
    }
  }

  Widget createInput() {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Dejar reseña'
          )),
         Row(
           mainAxisAlignment: MainAxisAlignment.end,
           children: [
             TextButton(
               style: ButtonStyle(
                 foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
               ),
               onPressed: () {
                 showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                        return Container(
                        height: 200,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)
                        ),
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const Text('¿La review contiene spoilers?', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w400)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red, // background
                                          onPrimary: Colors.white, // foreground
                                        ),
                                        child: const Text('Si', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w400)),
                                        onPressed: () =>{ this.leaveReview(_controller.text, hasSpoilers:true),  Navigator.pop(context) }
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green, // background
                                          onPrimary: Colors.white, // foreground
                                        ),
                                        child: const Text('No', style: TextStyle(fontSize: 40.0,fontWeight: FontWeight.w400)),
                                        onPressed: () => { this.leaveReview(_controller.text),  Navigator.pop(context) }
                                    )
                                  ],
                                )
                              ],
                          ),
                        )
                      );
                  });
                 },
               child: Text('Enviar'),
             ),
             TextButton(
               style: ButtonStyle(
                 foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
               ),
               onPressed: () { _controller.clear();},
               child: Text('Eliminar'),
             ),
           ],
         )
      ],
    );
  }
  ListView makeMovieReviews(List<Review> reviews) {
    List<Widget> reviewList = [this.createInput()];
    int i = 0;
    for(i ; i < reviews.length; i++) {
      Review reviewToDraw = reviews[i];
      reviewList.add(
          ReviewCard(
            review: reviewToDraw,
            movieTitle: this.movie.title,
            //todo ACA VA EL USUARIO QUE ESTE LOGEADO!
            username: "user_dos",
            callbackOnDelete: () => { this.reDraw() },
          )
      );
    }

    return ListView(children: reviewList);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 300),
            child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          FittedBox(
            child: Image(image: this.movie.movieImage.image),
            fit: BoxFit.fitWidth,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: isInList ? Icon(Icons.check, color: Colors.green) : Icon(Icons.add, size: 30),
                  onPressed: () {
                    var body = json.encode({"username": "user_dos", "elementTitle": this.movie.title});
                    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/addToWachtedList/"),
                                      headers: { 'Content-type': 'application/json', 'Accept': 'application/json'},
                                      body: body);

                    _response.then((value) => setState(() {this.isInList = json.decode(value.body);}));

                  },
              ),
              Text(this.movie.title,
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          RatingBar.builder(
            initialRating: this.movie.raiting.toDouble(),
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              rateMovie(rating);
            },
          ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("Genero: ${this.movie.title}", style: TextStyle(fontSize: 18.0)),
        ),
          Expanded(
              child:  this.movie.reviews.isEmpty  ? Column(children: [this.createInput(), Text('Se el primerx en dejar una review!',
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w400))],) : this.makeMovieReviews(this.movie.reviews)
          )
        ],
      ),
    )
    );
  }
}
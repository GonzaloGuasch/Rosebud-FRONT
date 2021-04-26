import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rosebud_front/widgets/review/review.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MovieScreem(this.movie)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: EdgeInsets.only(bottom: 20.0), height: 100.0, width: 312.0,
          decoration: BoxDecoration(border: Border.all()),
          child: Text(this.movie.title),
        )


    );
  }
}

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

  @override
  void initState()  {
    super.initState();
    final _response = http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/getByTitle/" + this.movie.title));
    setState(()  {
      _response.then((value) => {
          this.movie = Movie.fromJson(jsonDecode(value.body))
      });
    });
  }
  void rateMovie(rating) {
    final rate = rating.toInt();
    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/rate"),
        body: {'movieTitle': this.movie.title, 'rate': rate.toString()});
    _response.then((value) => {this.movie = Movie.fromJson(jsonDecode(value.body))});
  }

  void leaveReview(review) async{
    final _response = await http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/leaveReview/"),
                              body: {"movieTitle": this.movie.title, "username": 'usuarioUno', "review": review});
    if(_response.statusCode == 200) {
      //todo llevarme la 59-60 a una funcion para no repirme con redraw()
      var movieResultJSON = jsonDecode(_response.body);
      setState(() {
        this.movie = Movie.fromJson(movieResultJSON);
      });
    }
  }
  void reDraw() async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/getByTitle/" + this.movie.title));
    setState(()  {
      if(_response.statusCode == 200) {
        var movieResultJSON = jsonDecode(_response.body);
        this.movie = Movie.fromJson(movieResultJSON);
      }
    });
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
               onPressed: () {  this.leaveReview(_controller.text); },
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
  List<Widget> makeMovieReviews(List<Review> reviews) {
    List<Widget> reviewList = [this.createInput()];
    int i = 0;
    for(i ; i < reviews.length; i++) {
      Review reviewToDraw = reviews[i];
      reviewList.add(
          ReviewCard(
            review: reviewToDraw,
            movieTitle: this.movie.title,
            callbackOnDelete: () => { this.reDraw() },
          )
      );
    }
    return reviewList;
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: isInList ? Icon(Icons.check, color: Colors.green) : Icon(Icons.add, size: 30),
                  onPressed: () {
                    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/addToWachtedList/"), body: {"username": "usuario", "movieTitle": this.movie.title});
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
          Column(
              children:  movie.reviews.length != 0 ? makeMovieReviews(movie.reviews).toList() : [this.createInput()]
          ),
        ],
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'constants/constants.dart';
import 'data_model/Movie.dart';

void main() {
  runApp(RosebudApp());
}

class RosebudApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeChoice(),
    );
  }
}

class HomeChoice extends StatefulWidget {
  @override
  _HomeChoiceState createState() => _HomeChoiceState();
}

class _HomeChoiceState extends State<HomeChoice> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
            child:
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ELEGI LA CATEGORIA",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  IconButton(
                    icon: Icon(Icons.movie, size: 50),
                    tooltip: 'Movie section',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovieContainer()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.music_note, size: 50),
                    tooltip: 'Music section',
                    onPressed: () {
                    },
                  ),
                ],
              )
         ),
    );
  }
}

class MovieContainer extends StatefulWidget {
  @override
  _MovieContainerState createState() => _MovieContainerState();
}

class _MovieContainerState extends State<MovieContainer> {
  @override
  void initState() {
    final _response = http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/"));

    _response.then((value) => print(value.body))
             .catchError((onError) => print(onError));

    super.initState();
  }
  List _movieSearchResult = [];

  Future<void> makeSearch(String movieName) async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/searchByTitle/" + movieName));
    setState(()  {
      Iterable movieJsonList = jsonDecode(_response.body);
      List<Movie> movieResultList =  List<Movie>.from(movieJsonList.map((aMovieJson) => Movie.fromJson(aMovieJson)));
      _movieSearchResult = movieResultList;
    });
  }
  List<Widget> MakeMovieResults(List<Movie> movies) {
      List<Widget> movieList = [];
      int i = 0;
      for(i ; i < movies.length; i++) {
        Movie movieToDraw = movies[i];
        movieList.add(
            MovieCard(
              movie: movieToDraw
            )
        );
      }
      return movieList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children:
                <Widget>[Padding(
                  padding: const EdgeInsets.only(
                                  left: 40,
                                  top: 80,
                                  right: 40,
                                  bottom: 20,
                                ),
                  child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                                makeSearch(value);
                            },
                            decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Titulo de la pelicula'
                                    ),
                            ),
                ),
                Column(
                   children:  _movieSearchResult.length != 0 ? MakeMovieResults(_movieSearchResult).toList() : []
                ),
                ]
      ),
    );
  }
}


class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(movie.title);
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
class ReviewCard extends StatelessWidget {
  final Review review;
  final String movieTitle;
  final Function callbackOnDelete;

  const ReviewCard({Key key, this.review, this.movieTitle, this.callbackOnDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: const EdgeInsets.all(10.0),
            margin: EdgeInsets.only(bottom: 20.0, top: 15.0), height: 130.0, width: 312.0,
            decoration: BoxDecoration(border: Border.all(), color: Colors.white,),
            child: Column(
              children: [
                      Text(
                          this.review.review,
                          style: TextStyle(fontSize: 20),
                      ),
                      Row(
                        children: [
                                Padding(
                                    padding: const EdgeInsets.only(left: 120.0, top: 10.0),
                                    child: Text(
                                            this.review.userCreate,
                                            style: TextStyle(fontSize: 20),
                                    ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 1.0, top: 11.0),
                                  child: IconButton(
                                          icon: const Icon(Icons.delete_outline),
                                          iconSize: 35.0,
                                          color: Colors.red,
                                          onPressed: () async {
                                            final _response = await http.delete(Uri.http(BACKEND_PATH_LOCAL, "review/delete/" + this.movieTitle + '/' + this.review.id.toString()));
                                            if(_response.statusCode == 200) {
                                                callbackOnDelete();
                                            }
                                          })
                                )]
                      ),
              ],
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
  _MovieScreemState(this.movie);

  void rateMovie(rating) {
    final rate = rating.toInt();
    final _response = http.post(Uri.http(BACKEND_PATH_LOCAL, "movie/rate"),
                                body: {'movieTitle': this.movie.title, 'rate': rate.toString()});
    //REFRESH DE WIDGET
  }
  void reDraw() async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "movie/searchByTitle/" + this.movie.title));
    setState(()  {
      Iterable movieJsonList = jsonDecode(_response.body);
      List<Movie> movieResultList =  List<Movie>.from(movieJsonList.map((aMovieJson) => Movie.fromJson(aMovieJson)));
      this.movie = movieResultList.first;
    });
  }

   List<Widget> makeMovieReviews(List<Review> reviews) {
     List<Widget> reviewList = [];
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
          Text(this.movie.title,
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
            ),
          ),
          RatingBar.builder(
            initialRating: 3,
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
              children:  movie.reviews.length != 0 ? makeMovieReviews(movie.reviews).toList() : []
          ),
        ],
      ),
    );
  }
}

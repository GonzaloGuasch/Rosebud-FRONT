import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:rosebud_front/widgets/review/LeaveReview.dart';
import 'MovieDescriptionInfo.dart';
import 'MoviePointReview.dart';
import 'MovieReviewsFromUser.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;
  final LocalStorage storage;
  const MovieDetail(this.movie, this.storage, {Key key}) : super(key : key);

  @override
  _MovieDetailState createState() => _MovieDetailState(movie);
}

class _MovieDetailState extends State<MovieDetail> {
  Movie movie;
  _MovieDetailState(this.movie);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeatureDiscovery.discoverFeatures(context,
          <String>[
            "adddMovie",
          ]
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xff181b20),
      child: ListView(
        children: [
          Container(
          child: DescribedFeatureOverlay(
                  featureId: 'adddMovie',
                  targetColor: Colors.white,
                  textColor: Colors.black,
                  backgroundColor: Colors.green.shade400,
                  contentLocation: ContentLocation.trivial,
                  title: Text('Info de la peli', style: TextStyle(fontSize: 20.0)),
                  pulseDuration: Duration(seconds: 1),
                  enablePulsingAnimation: true,
                  barrierDismissible: false,
                  overflowMode: OverflowMode.wrapBackground,
                  openDuration: Duration(seconds: 1),
                  description: Text('Agrega la peli a tu lista de vistas, deja tu puntuación si te gusto y lee las reviews de otrxs usuarixs!'),
                  tapTarget: Icon(Icons.movie),
                    child: Image(image: this.movie.movieImage.image)
          )),
          Container(
          child: MovieDescriptionInfo(
                      movieTitle: this.movie.title,
                      movieDirector: this.movie.director,
                      movieDescription: 'A human soldier is sent from 2029 to 1984 to stop an almost indestructible cyborg killing machine, sent from the same year, which has been programmed to execute a young woman whose unborn son is the key to humanitys future salvation.',
                ),
          ),
          Container(
              child: MoviePointReview(
                      movieTitle: this.movie.title,
                      ratingInMovie: this.movie.raiting.toDouble()
                  )
            ),
          Container(
            child: LeaveReview(
                    movieTitle: this.movie.title,
                    storage: widget.storage
                  )
          ),
          Container(
            child: MovieReviewsFromUser(
                    movieTitle: this.movie.title,
                    movieReviews: this.movie.reviews,
            ),
          )
        ],
      ),
    );
  }
}
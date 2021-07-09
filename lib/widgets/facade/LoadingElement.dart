import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ALoadingElement(),
          ALoadingElement(),
          ALoadingElement(),
          ALoadingElement(),
        ],
      )
    );
  }
}



class ALoadingElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[100],
          highlightColor: Colors.grey[900],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 175,
                color: Colors.white,
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child:
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      children: [
                        Container(
                          width: 240,
                          height: 20,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            width: 240,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: 240,
                          height: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

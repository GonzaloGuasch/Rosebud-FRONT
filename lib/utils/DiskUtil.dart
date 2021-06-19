import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rosebud_front/constants/constants.dart';
import 'package:rosebud_front/data_model/Disk.dart';
import 'package:http/http.dart' as http;
import 'package:rosebud_front/data_model/Movie.dart';
import 'package:rosebud_front/widgets/facade/ElementCard.dart';

class DiskUtil {

  static Future<List<Disk>> makeDiskResult(String diskTitle) async {
    final _response = await http.get(Uri.http(BACKEND_PATH_LOCAL, "disk/searchByTitle/" + diskTitle));
    List diskJsonList = jsonDecode(_response.body);
    List<Disk> diskResultList =  List<Disk>.from(diskJsonList.map((aDiskJson) => Disk.fromJson(aDiskJson)));
    return diskResultList;
  }


  static Widget createAllResults(List<ElementObject> diskSearchResult, LocalStorage storage) {
    List<Widget> list = [];
    for(int i = 0; i < diskSearchResult.length; i++) {
      Disk diskCardResult = diskSearchResult[i];
      list.add(
        ElementCard(
          element: diskCardResult,
          storage: storage,
          isMoveCard: false,
        ),
      );
    }
    return new Column(children: list);
  }
}

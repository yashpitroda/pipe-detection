import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:pipe_detection_app/model/prediction.dart';
import 'package:pipe_detection_app/services/secrat/secret.dart';

import '../services/util.dart';

class PredictionProvider with ChangeNotifier {
  bool isLoadingForfetch = false;

  bool get getIsLoadingForfetch {
    return isLoadingForfetch;
  }

  List<Prediction>? _predictionList;

  List<Prediction>? get getPredictionList {
    return _predictionList == null ? null : [..._predictionList!];
  }

  Future<void> fetchPrediction() async {
    print("fetchPrediction is call");

    final url = Uri.parse(Secrets.API_URL + "/fetchPrediction");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {},
      ),
    );
    if (response.body == 'null') {
      return;
    }
    final responseData = json.decode(response.body);
    final responseList = responseData["payload"];

    final List<Prediction> temp = [];
    responseList.forEach((element) {
      temp.add(Prediction(
        id: element['id'].toString(),
        inputImageUrl: element["inputImageUrl"].toString(),
        outputImageUrl: element['outputImageUrl'].toString(),
        date: DateTime.parse(element["date"].toString()),
        count: element['count'].toString(),
      ));
    });
    _predictionList = temp;
    print(_predictionList);
    notifyListeners();
  }
}

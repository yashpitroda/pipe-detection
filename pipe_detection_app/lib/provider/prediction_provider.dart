import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pipe_detection_app/model/prediction.dart';

import '../services/util.dart';

class PredictionProvider with ChangeNotifier {
  bool isLoadingForfetch = false;

  bool get getIsLoadingForfetch {
    return isLoadingForfetch;
  }

  List<Prediction>? _predictionList;

  Future<void> fetchAccount() async {
    print("fetchAccount is call");

    final url = Uri.parse(Util.API_URL + "/fetchPrediction");
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
    List responseSupplierDataList = responseData['payload'];
    final List<Prediction> temp = [];
    final stirngToDateTmeFormatter = DateFormat('EEE, d MMM yyyy HH:mm:ss');

    responseSupplierDataList.forEach((element) {
      temp.add(Prediction(
        remark: element['id'].toString(),
        id: element['id'].toString(),
        inputUrl: element["inputUrl"].toString(),
        outputUrl: element['outputUrl'].toString(),
        date: stirngToDateTmeFormatter.parse(element["date"]),
        count: element['count'].toString(),
      ));
    });
    _predictionList = temp;
    print(_predictionList);
    notifyListeners();
  }
}

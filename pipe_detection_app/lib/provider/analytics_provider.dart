import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../services/util.dart';

class AnalyticsProvider with ChangeNotifier {
  bool isInputImgSelected=true;
  bool get getIsInputImgSelected{
    return isInputImgSelected;
  }
  void changeIsInputImgSelected({required bool newbool}){
    isInputImgSelected=newbool;
    notifyListeners();
  }
}
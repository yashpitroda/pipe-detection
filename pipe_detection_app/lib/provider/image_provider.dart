import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageProviderr with ChangeNotifier {
  XFile? selectedImage;
  XFile? get getImage{
    return selectedImage;
  }
  void setImage({required XFile? img}) {
    selectedImage = img;
    print("cal");
    notifyListeners();
  }
}

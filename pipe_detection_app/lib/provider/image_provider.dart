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

class ImageProviderr with ChangeNotifier {
  bool isLoading = false;
  XFile? selectedImage;
  XFile? responseImage;
  String? responseBase64Image;
  String? responseCount;

  bool get getIsLoading {
    return isLoading;
  }

  XFile? get getSelectedImage {
    return selectedImage;
  }

  XFile? get getResponseImage {
    return responseImage;
  }

  String? get getResponseBase64Image {
    return responseBase64Image;
  }

  String? get getResponseCount {
    return responseCount;
  }

  void emptyImageProvidrr() {
    selectedImage = null;
    responseBase64Image = null;
    responseCount = null;
    notifyListeners();
  }

  void setImage({required XFile? img}) {
    selectedImage = img;
    notifyListeners();
  }

  File convertXFileToFile(XFile xfile) {
    File file = File(xfile.path);
    print('File path: ${file.path}');
    return file;
  }

  Future<void> detectPipe() async {
    if (selectedImage == null) {
      return;
    }
    isLoading = true;
    notifyListeners();

    final url = Uri.parse(Util.API_URL + "/detectPipe");

    String base64imageStirng =
        await Util.imageToBase64String(img: selectedImage!);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {'image': base64imageStirng},
      ),
    );
    if (response.body == 'null') {
      return;
    }

    final responseData = json.decode(response.body);
    final resMap = responseData['payload'];
    responseBase64Image = resMap['base64imageStirng'];
    responseImage = await Util.convertBase64ToXFIle(responseBase64Image!);

    responseCount = resMap['count'];
    isLoading = false;
    notifyListeners();
  }

  Future<String> uploadImageOnFirebaseStorage(
      {required XFile uploadImage}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final mountainImagesRef =
        storageRef.child("images/${Util.generateUniqueId()}.jpg");
    try {
      await mountainImagesRef.putFile(convertXFileToFile(selectedImage!));
    } on Exception catch (e) {
      print(e);
    }
    String uploadedImageUrl = await mountainImagesRef.getDownloadURL();
    return uploadedImageUrl;
  }

  Future<String> uploadBase64ImageOnFirebaseStorage(
      {required String base64imageStirng}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final Ref = storageRef.child("images/${Util.generateUniqueId()}.jpg");
    try {
      String data = "data:text/plain;base64," + responseBase64Image!;
      await Ref.putString(data, format: PutStringFormat.dataUrl);
    } on Exception catch (e) {
      print(e);
    }
    String uploadedImageUrl = await Ref.getDownloadURL();
    return uploadedImageUrl;
  }

  Future<void> uploadImage() async {
    if (selectedImage == null ||
        responseBase64Image == null ||
        responseCount == null) {
      return;
    }
    isLoading = true;
    notifyListeners();

    //selectedImage upload on firebase
    String inputImageUrl =
        await uploadImageOnFirebaseStorage(uploadImage: selectedImage!);
    XFile vb = await Util.convertBase64ToXFIle(responseBase64Image!);
    // String outputImageUrl=await uploadBase64ImageOnFirebaseStorage(base64imageStirng: responseBase64Image!);
    print("mnmnmn");
    String outputImageUrl =
        await uploadImageOnFirebaseStorage(uploadImage: responseImage!);

    //now store in database
    final url = Uri.parse(Util.API_URL + "/uploadImage");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          'inputImageUrl': inputImageUrl,
          'outputImageUrl': outputImageUrl,
          "count": responseCount
        },
      ),
    );
    if (response.body == 'null') {
      return;
    }

    final responseData = json.decode(response.body);
    // final resMap = responseData['payload'];
    // responseBase64Image = resMap['base64imageStirng'];
    // responseCount = resMap['count'];
    print(responseData);
    isLoading = false;
    notifyListeners();
  }

  // Future<XFile> byteStringToFileImage(String base64Image) async {
  //   final imageBytes = base64.decode(base64Image);
  //   XFile selectedImage = XFile.fromData(imageBytes);
  //   return selectedImage;
  // }

  // Future<Uint8List> returnbyte(String base64Image) async {
  //   final imageBytes = base64Decode(base64Image);
  //   return imageBytes;
  // }
}

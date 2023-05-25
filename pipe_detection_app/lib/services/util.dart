import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Util {
  static const API_URL =
      "http://192.168.43.144:6000"; ////http://192.168.1.123:9000 //http://192.168.43.144:6000 //https://pipe-fpks.onrender.com

  static void removeFocus({required BuildContext context}) {
    //removeFocus -- remove keybord or all focusNode
    FocusScope.of(context).unfocus();
  }

  static Future<String> getImageFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDocumentsDirectory.path}/${generateUniqueId()}.jpg';
    return filePath;
  }

  static File convertBase64ToFile(String base64String, String filePath) {
    List<int> bytes = base64Decode(base64String);
    File file = File(filePath);
    file.writeAsBytesSync(bytes);
    return file;
  }

  static XFile convertFileToXFile(File file) {
    XFile xfile = XFile(file.path);
    // Now you can use the 'xfile' object as a regular XFile
    return xfile;
  }

  static Future<XFile> convertBase64ToXFIle(String base64String) async {
    String x = await getImageFilePath();
    File a = convertBase64ToFile(base64String, x);
    return convertFileToXFile(a);
  }

  static Future<String> imageToBase64String({required XFile img}) async {
    List<int> imageBytes = await img.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  static String generateUniqueId() {
    return const Uuid().v4();
  }

  static void scrollUp({required ScrollController customScrollController}) {
    customScrollController.animateTo(
      customScrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }
}

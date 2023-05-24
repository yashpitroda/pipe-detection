import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pipe_detection_app/palette.dart';
import 'package:pipe_detection_app/provider/image_provider.dart';
import 'package:pipe_detection_app/widget/badge.dart';
import 'package:pipe_detection_app/widget/image_input_v2.dart';
import 'package:provider/provider.dart';

// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// // ...

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  // XFile? _selectedimagefomImageInput;

  // void _selectimageHandler(XFile? pickedImage) {
  //   // setState(() {
  //   _selectedimagefomImageInput = pickedImage;
  //   print("object");
  //   print(_selectedimagefomImageInput);
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pipe Detection App"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(126.0),
          child: Container(
            // color: Colors.amber,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Container(
                  // color: Colors.green,
                  child: ImageInputV2(),
                ),
                // SizedBox(
                //   height: 6,
                // ),
                Expanded(
                  child: Container(
                    height: 120,
                    // color: Colors.pink,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Consumer<ImageProviderr>(
                          builder: (context, imageProviderr, child) {
                            return OutlinedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Palette.backgroundColor),
                                onPressed: imageProviderr.getIsLoading
                                    ? null
                                    : () async {
                                        await Provider.of<ImageProviderr>(
                                                context,
                                                listen: false)
                                            .detectPipe();
                                      },
                                icon: const Icon(
                                    Icons.wifi_protected_setup_sharp),
                                label: imageProviderr.getIsLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(),
                                      )
                                    : const Text("Detect Pipe"));
                          },
                        ),
                        OutlinedButton.icon(
                            onPressed: () {
                              Provider.of<ImageProviderr>(context,
                                      listen: false)
                                  .emptyImageProvidrr();
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            label: const Text("Delete"))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              height: 300,
              width: 300,
              child: Consumer<ImageProviderr>(
                builder: (context, imageProviderr, child) {
                  return (imageProviderr.responseBase64Image != null)
                      ? Image.memory(
                          // imageProviderr.getimageBytes!,
                          base64.decode(
                              imageProviderr.responseBase64Image as String),
                          errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) =>
                              const Center(
                                  child:
                                      Text('This image type is not supported')),
                        )
                      : const Text(
                          'Tap to select image',
                          textAlign: TextAlign.center,
                        );
                },
              ),
            ),
            Text("using XFile"),
            Container(
              height: 300,
              width: 300,
              child: Consumer<ImageProviderr>(
                builder: (context, imageProviderr, child) {
                  return (imageProviderr.responseImage != null)
                      ? Image.file(
                          File(imageProviderr.responseImage!.path),
                          errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) =>
                              const Center(
                                  child:
                                      Text('This image type is not supported')),
                        )
                      : const Text(
                          'Tap to select image',
                          textAlign: TextAlign.center,
                        );
                },
              ),
            ),
            Consumer<ImageProviderr>(
              builder: (context, imageProviderr, child) {
                return (imageProviderr.getResponseCount != null)
                    ? Text(
                        imageProviderr.getResponseCount!,
                        style: Theme.of(context).textTheme.labelMedium,
                      )
                    : Text("not data");
              },
            ),
            OutlinedButton.icon(
                onPressed: () {
                  Provider.of<ImageProviderr>(context, listen: false)
                      .uploadImage();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: const Text("upload"))
          ],
        ),
      ),
    );
  }
}

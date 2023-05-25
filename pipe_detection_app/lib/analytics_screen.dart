import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pipe_detection_app/provider/analytics_provider.dart';
import 'package:pipe_detection_app/provider/image_provider.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatelessWidget {
  static const routeName = '/AnalyticsScreen';
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Analytics"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(170.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Consumer2<ImageProviderr, AnalyticsProvider>(
                        builder: (context, imageProviderr, analyticsProvider,
                            child) {
                          return inoutImageCard(
                            isThisCardIsInputimage: true,
                            title: "input image",
                            onTap: () {
                              Provider.of<AnalyticsProvider>(context,
                                      listen: false)
                                  .changeIsInputImgSelected(newbool: true);
                            },
                            fileImagePath:
                                imageProviderr.getSelectedImage!.path,
                            isInputImgSelected:
                                analyticsProvider.getIsInputImgSelected,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Consumer2<ImageProviderr, AnalyticsProvider>(
                        builder: (context, imageProviderr, analyticsProvider,
                            child) {
                          return inoutImageCard(
                            isThisCardIsInputimage: false,
                            title: "Output image",
                            onTap: () {
                              Provider.of<AnalyticsProvider>(context,
                                      listen: false)
                                  .changeIsInputImgSelected(newbool: false);
                            },
                            fileImagePath:
                                imageProviderr.getResponseImage!.path,
                            isInputImgSelected:
                                analyticsProvider.getIsInputImgSelected,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  child: Text("Pipe Count",
                      style: Theme.of(context).textTheme.titleSmall),
                ),
                Consumer<ImageProviderr>(
                  builder: (context, imageProviderr, child) {
                    return imageProviderr.getResponseCount != null
                        ? Text(imageProviderr.getResponseCount!,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    // color:
                                    //     Theme.of(context).indicatorColor
                                    ))
                        : Text("Null",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Theme.of(context).focusColor));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Consumer<AnalyticsProvider>(
              builder: (context, analyticsProvider, child) {
                return analyticsProvider.getIsInputImgSelected
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Input image",
                              style: Theme.of(context).textTheme.bodySmall),
                          SizedBox(
                            height: 2,
                          ),
                          Consumer<ImageProviderr>(
                            builder: (context, imageProviderr, child) {
                              return (imageProviderr.selectedImage != null)
                                  ? Image.file(
                                      File(imageProviderr.selectedImage!.path),
                                      errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) =>
                                          const Center(
                                              child: Text(
                                                  'This image type is not supported')),
                                    )
                                  : const Text(
                                      'Tap to select image',
                                      textAlign: TextAlign.center,
                                    );
                            },
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Output image",
                              style: Theme.of(context).textTheme.bodySmall),
                          SizedBox(
                            height: 2,
                          ),
                          Consumer<ImageProviderr>(
                            builder: (context, imageProviderr, child) {
                              return (imageProviderr.responseImage != null)
                                  ? Image.file(
                                      File(imageProviderr.responseImage!.path),
                                      errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) =>
                                          const Center(
                                              child: Text(
                                                  'This image type is not supported')),
                                    )
                                  : const Text(
                                      'Tap to select image',
                                      textAlign: TextAlign.center,
                                    );
                            },
                          ),
                        ],
                      );
              },
            ),
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
    );
  }
}

class inoutImageCard extends StatelessWidget {
  inoutImageCard({
    super.key,
    required this.fileImagePath,
    required this.onTap,
    required this.title,
    required this.isInputImgSelected,
    required this.isThisCardIsInputimage,
  });

  String title;
  Function onTap;
  String fileImagePath;
  bool isInputImgSelected;
  bool isThisCardIsInputimage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(
          height: 2,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 3,
          child: Container(
            width: 200,
            child: InkWell(
              onTap: () {
                print("mm");
                onTap();
              },
              child: Container(
                decoration: (isThisCardIsInputimage)
                    ? BoxDecoration(
                        color: (isInputImgSelected)
                            ? Theme.of(context).primaryColorLight
                            : Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            width: 2,
                            color: (isInputImgSelected)
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor),
                      )
                    : BoxDecoration(
                        color: (isInputImgSelected)
                            ? Theme.of(context).canvasColor
                            : Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            width: 2,
                            color: (isInputImgSelected)
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).primaryColor),
                      ),

                height: 100,
                // width: 200,
                child: Card(
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Image.file(
                      // imageProviderr.getResponseImage!.path
                      File(fileImagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) =>
                          const Center(
                              child: Text('This image type is not supported')),
                    )),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

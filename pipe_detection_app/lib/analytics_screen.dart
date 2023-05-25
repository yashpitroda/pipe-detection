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
            // color: Colors.amber,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Input image",
                              style: Theme.of(context).textTheme.titleSmall),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            width: 200,
                            child: Consumer2<ImageProviderr, AnalyticsProvider>(
                              builder: (context, imageProviderr,
                                  analyticsProvider, child) {
                                return InkWell(
                                  onTap: () {
                                    Provider.of<AnalyticsProvider>(context,
                                            listen: false)
                                        .changeIsInputImgSelected(
                                            newbool: true);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: (analyticsProvider
                                              .getIsInputImgSelected)
                                          ? Theme.of(context).primaryColorLight
                                          : Theme.of(context).hoverColor,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          width: 2,
                                          color: (analyticsProvider
                                                  .getIsInputImgSelected)
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context)
                                                  .disabledColor),
                                    ),

                                    height: 100,
                                    // width: 200,
                                    child: Card(
                                      elevation: 5,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 4),
                                      child: (imageProviderr.getSelectedImage !=
                                              null)
                                          ? Image.file(
                                              File(imageProviderr
                                                  .getSelectedImage!.path),
                                              fit: BoxFit.cover,
                                              errorBuilder: (BuildContext
                                                          context,
                                                      Object error,
                                                      StackTrace? stackTrace) =>
                                                  const Center(
                                                      child: Text(
                                                          'This image type is not supported')),
                                            )
                                          : const Text(
                                              'Tap to select image',
                                              textAlign: TextAlign.center,
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Output image",
                              style: Theme.of(context).textTheme.titleSmall),
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
                              child:
                                  Consumer2<ImageProviderr, AnalyticsProvider>(
                                builder: (context, imageProviderr,
                                    analyticsProvider, child) {
                                  return InkWell(
                                    onTap: () {
                                      Provider.of<AnalyticsProvider>(context,
                                              listen: false)
                                          .changeIsInputImgSelected(
                                              newbool: false);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: (analyticsProvider
                                                .getIsInputImgSelected)
                                            ? Theme.of(context).canvasColor
                                            : Theme.of(context)
                                                .primaryColorLight,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            width: 2,
                                            color: (analyticsProvider
                                                    .getIsInputImgSelected)
                                                ? Theme.of(context)
                                                    .disabledColor
                                                : Theme.of(context)
                                                    .primaryColor),
                                      ),

                                      height: 100,
                                      // width: 200,
                                      child: Card(
                                        elevation: 5,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 4),
                                        child: (imageProviderr.responseImage !=
                                                null)
                                            ? Image.file(
                                                // base64.decode(imageProviderr
                                                //     .responseBase64Image!),
                                                File(imageProviderr
                                                    .getResponseImage!.path),
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                            context,
                                                        Object error,
                                                        StackTrace?
                                                            stackTrace) =>
                                                    const Center(
                                                        child: Text(
                                                            'This image type is not supported')),
                                              )
                                            : const Text(
                                                'Tap to select image',
                                                textAlign: TextAlign.center,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  // color: Colors.amber,
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
          OutlinedButton.icon(
              onPressed: () {
                // Navigator.of(context).push(_createRoute());
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              label: const Text("pink")),
          // FittedBox(
          //   child: Consumer<ImageProviderr>(
          //     builder: (context, imageProviderr, child) {
          //       return (imageProviderr.responseBase64Image != null)
          //           ? Image.memory(
          //               // imageProviderr.getimageBytes!,
          //               base64.decode(
          //                   imageProviderr.responseBase64Image as String),
          //               errorBuilder: (BuildContext context, Object error,
          //                       StackTrace? stackTrace) =>
          //                   const Center(
          //                       child:
          //                           Text('This image type is not supported')),
          //             )
          //           : const Text(
          //               'Tap to select image',
          //               textAlign: TextAlign.center,
          //             );
          //     },
          //   ),
          // ),
          Text("using XFile"),
          Container(
            // height: 300,
            // width: 300,
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
    );
  }
}

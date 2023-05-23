import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pipe_detection_app/provider/image_provider.dart';
import 'package:provider/provider.dart';

class ImageInput extends StatefulWidget {
  final Function onselectImage;

  const ImageInput({super.key, required this.onselectImage});
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  Icon iconGallery = const Icon(Icons.image);
  Icon iconCamera = const Icon(Icons.camera);
  Icon iconRemove = const Icon(Icons.delete);

  final ImagePicker _picker = ImagePicker();
  XFile? finalImage;

  Future<void> _onImageButtonPressed(
    ImageSource _source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: _source,
        );
        if (pickedFile == null) {
          return;
        }
        finalImage = pickedFile;
        // widget.onselectImage(finalImage);
        Provider.of<ImageProviderr>(context, listen: false)
            .setImage(img: finalImage);
      } catch (e) {
        print(e);
      }
    }
  }

  void _emptyIMGBox() {
    finalImage = null;
    Provider.of<ImageProviderr>(context, listen: false)
        .setImage(img: finalImage);
  }

  @override
  Widget build(BuildContext context) {
    // XFile? seletedimg = Provider.of<ImageProviderr>(context).getImage;
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                context: context,
                builder: (_) {
                  return Container(
                    height: 100,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                  icon: iconGallery,
                                  onPressed: () => _onImageButtonPressed(
                                      ImageSource.gallery,
                                      context: context)),
                              const Text('Gallery'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  icon: iconCamera,
                                  onPressed: () => _onImageButtonPressed(
                                      ImageSource.camera,
                                      context: context)),
                              const Text('Camara'),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: iconRemove,
                                onPressed: () => _emptyIMGBox(),
                              ),
                              const Text('Delete'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
          child: Container(
            width: 200,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
            ),
            child: null,
            // (seletedimg != null)
            //     ? Image.file(
            //         File(seletedimg.path),
            //         errorBuilder: (BuildContext context, Object error,
            //                 StackTrace? stackTrace) =>
            //             const Center(
            //                 child: Text('This image type is not supported')),
            //       )
            //     : const Text(
            //         'Tap to select image',
            //         textAlign: TextAlign.center,
            //       ),
            alignment: Alignment.center,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        // Expanded(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.stretch,
        //     children: [
        //       ElevatedButton.icon(
        //           icon: iconGallery,
        //           label: const Text('from Gallery'),
        //           onPressed: () => _onImageButtonPressed(ImageSource.gallery,
        //               context: context)),
        //       ElevatedButton.icon(
        //           icon: iconCamera,
        //           label: const Text('from camara'),
        //           onPressed: () => _onImageButtonPressed(ImageSource.camera,
        //               context: context)),
        //       ElevatedButton.icon(
        //         icon: iconRemove,
        //         label: const Text('remove'),
        //         onPressed: () => _emptyIMGBox(),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

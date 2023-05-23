import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pipe_detection_app/widget/image_input_v2.dart';
import 'package:provider/provider.dart';
import 'widget/image_input.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  XFile? _selectedimagefomImageInput;

  void _selectimageHandler(XFile? pickedImage) {
    // setState(() {
    _selectedimagefomImageInput = pickedImage;
    print("object");
    print(_selectedimagefomImageInput);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Pipe Detection App"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(126.0),
          child: Container(
            // color: Colors.amber,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    // color: Colors.pink,
                    child: ImageInputV2(),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.wifi_protected_setup_sharp),
                            label: const Text("Detect Pipe")),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pipe_detection_app/analytics_screen.dart';
import 'package:pipe_detection_app/palette.dart';
import 'package:pipe_detection_app/provider/image_provider.dart';
import 'package:pipe_detection_app/provider/prediction_provider.dart';
import 'package:pipe_detection_app/services/date_time_utill.dart';
import 'package:pipe_detection_app/services/widget_component_utill.dart';
import 'package:pipe_detection_app/widget/image_input_v2.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AnalyticsScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return oldScaffold(context);
  }

  WillPopScope oldScaffold(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Exit'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              ElevatedButton(
                child: const Text('No'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              OutlinedButton(
                child: const Text('Yes'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Pipe Detection App"),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(126.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    ImageInputV2(),
                    Expanded(
                      child: Container(
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Consumer<ImageProviderr>(
                              builder: (context, imageProviderr, child) {
                                return OutlinedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Palette.backgroundColor),
                                    onPressed: imageProviderr.getIsLoading
                                        ? null
                                        : () async {
                                            await Provider.of<ImageProviderr>(
                                                    context,
                                                    listen: false)
                                                .detectPipe()
                                                .then((value) {
                                              if (value) {
                                                Navigator.of(context)
                                                    .push(_createRoute());
                                              } else {
                                                WidgetComponentUtill
                                                    .displaysnackbar(
                                                  context: context,
                                                  message: "Select Image First",
                                                );
                                              }
                                            });
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
                                label: const Text("Delete")),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          body: FutureBuilder(
            future: Future.wait([
              Provider.of<PredictionProvider>(context, listen: false)
                  .fetchPrediction(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8 * 1.6),
                        child: Text("Saved Predictions",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Consumer<PredictionProvider>(
                        builder: (context, predictionProvider, child) {
                          // List<Prediction>? l=predictionProvider.getPredictionList;
                          return predictionProvider.getPredictionList == null
                              ? WidgetComponentUtill.loadingIndicator()
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: predictionProvider
                                      .getPredictionList!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding:
                                          const EdgeInsets.only(left: 8 * 1.6),
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(6 * 2),
                                                bottomLeft:
                                                    Radius.circular(6 * 2))),
                                        elevation: 0.7,
                                        child: ListTile(
                                          title: Text(
                                            DateTimeUtill.returndateTimeDay(
                                                souceDateTime:
                                                    predictionProvider
                                                        .getPredictionList![
                                                            index]
                                                        .date),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Count ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!,
                                                  ),
                                                  Text(
                                                    predictionProvider
                                                        .getPredictionList![
                                                            index]
                                                        .count,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ImageCardSmall(
                                                placeholderImageString:
                                                    "assets/png/icons8-loading-104(-xxxhdpi).png",
                                                networkImageUrl:
                                                    predictionProvider
                                                        .getPredictionList![
                                                            index]
                                                        .inputImageUrl,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              ImageCardSmall(
                                                placeholderImageString:
                                                    "assets/png/icons8-loading-104(-xxxhdpi).png",
                                                networkImageUrl:
                                                    predictionProvider
                                                        .getPredictionList![
                                                            index]
                                                        .outputImageUrl,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      )
                    ],
                  ),
                );
              } else {
                return WidgetComponentUtill.loadingIndicator();
              }
            },
          )),
    );
  }
}

class ImageCardSmall extends StatelessWidget {
  ImageCardSmall({
    super.key,
    required this.placeholderImageString,
    required this.networkImageUrl,
  });

  final String placeholderImageString;
  final String networkImageUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Image preview'),
            content: FadeInImage(
              placeholder: AssetImage(
                  placeholderImageString), //it is provider //whcin img load then it show
              image: NetworkImage(
                  networkImageUrl), //after this show with aniamtion
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        child: FadeInImage(
          height: 60, width: 60,
          placeholder: AssetImage(
              placeholderImageString), //it is provider //whcin img load then it show
          image: NetworkImage(networkImageUrl), //after this show with aniamtion
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

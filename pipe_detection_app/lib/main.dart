import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pipe_detection_app/analytics_screen.dart';
import 'package:pipe_detection_app/firebase_options.dart';
import 'package:pipe_detection_app/home_screen.dart';
import 'package:pipe_detection_app/provider/analytics_provider.dart';
import 'package:pipe_detection_app/provider/image_provider.dart';
import 'package:provider/provider.dart';

import 'palette.dart';

// void main() {
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext ctx) => ImageProviderr(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => AnalyticsProvider(),
        ),
      ],
      child: MaterialApp(
          scrollBehavior: const ScrollBehavior(
              androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            cardTheme: const CardTheme(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 3)),
            primarySwatch: generateMaterialColor(Palette.primaryColor),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              extendedTextStyle: Theme.of(context).textTheme.button,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            scaffoldBackgroundColor: Palette.backgroundColor,
            textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: Palette.fontBlackColor)
                .copyWith(),
            appBarTheme: const AppBarTheme(
              elevation: 0.4,
              backgroundColor: Colors.white,
              foregroundColor: Palette.blackColor,
            ),
            // colorScheme: const ColorScheme(
            //     brightness: Brightness.light,
            //     primary: Palette.primaryColor,
            //     onPrimary: Palette.fontWhiteColor,
            //     secondary: Colors.amber,
            //     onSecondary: Palette.fontBlackColor,
            //     error: Palette.redColor,
            //     onError: Palette.fontWhiteColor,
            //     background: Palette.fontWhiteColor,
            //     onBackground: Palette.fontWhiteColor,
            //     surface: Palette.fontWhiteColor,
            //     onSurface: Palette.fontBlackColor),
          ),
          // theme: ThemeData(
          //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
          //   useMaterial3: true,
          // ),
          home: HomeScreen(),
          routes: {
            AnalyticsScreen.routeName: (context) => const AnalyticsScreen(),
          }),
    );
  }
}

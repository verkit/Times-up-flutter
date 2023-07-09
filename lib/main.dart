import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parental_control/services/app_usage_service.dart';
import 'package:parental_control/services/auth.dart';
import 'package:parental_control/services/geo_locator_service.dart';
import 'package:parental_control/services/internet_service.dart';
import 'package:parental_control/services/internet_service.dart';
import 'package:parental_control/theme/theme.dart';
import 'package:provider/provider.dart';

import 'app/config/screencontroller_config.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

//TODO: ADD easyLocalization to translate app
//TODO: Write all strings in a Class
//TODO: Add contactUs page
//TODO: Share UNIQUE CODE

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
       Provider<AuthBase>(create: (context) => Auth()),
        Provider<AppUsageService>(create: (context) => AppUsageService()),
        Provider<GeoLocatorService>(
          create: (context) => GeoLocatorService()..getInitialLocation(),
        ),
        ChangeNotifierProvider<InternetService>(
            create: (context) => InternetService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final geoService = Provider.of<GeoLocatorService>(context, listen: false);
    // final apps = Provider.of<AppUsageService>(context, listen: false);
    final internetService =
        Provider.of<InternetService>(context, listen: false);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Parental Control',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: FutureBuilder(
            future: Future.wait([
              geoService.getInitialLocation(),
              //  apps.getAppUsageService(),
            ]),
            builder: (context, _) {
              return Scaffold(body: ScreensController());
            }));
  }
}

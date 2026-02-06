// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// // import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:gocut_vendor/color/colors.dart';
// import 'package:gocut_vendor/firebase_options.dart';
// import 'package:gocut_vendor/global/data.dart';
// import 'package:gocut_vendor/lib/constants/dependency_injection.dart';
// import 'package:gocut_vendor/lib/controllers/maincontroller.dart';
// // import 'controllers/maincontroller.dart';
// import 'localNotifications.dart';
// import 'repo/repos.dart';
// import 'splash_screen.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:provider/provider.dart';

// Future<void> _firebaseMessagingBackgroundHandler(message) async {
//   await Firebase.initializeApp();
//   LocalNotification.showNotification(message);
//   print('Handling a background message ${message.messageId}');
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

//   // // Pass all uncaught errors from the framework to Crashlytics.
//   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

//   runApp(MultiProvider(providers: [
//     ChangeNotifierProvider(
//       create: (context) => Maincontroller(),
//     ),
//   ], child: MyApp()));

//   DependencyInjection.init(); // Initialize all dependencies here
//  configureEasyLoading(); // Configure EasyLoading styles
// }

// void configureEasyLoading() {
//   EasyLoading.instance
//     ..indicatorType = EasyLoadingIndicatorType.fadingCircle // Spinner style
//     ..loadingStyle = EasyLoadingStyle.custom // Custom loading style
//     ..backgroundColor = Colors.white // White background
//     ..indicatorColor = Colors.blue // Blue spinner
//     ..textColor = Colors.blue // Blue text
//     ..maskColor = Colors.black.withOpacity(0.5) // Semi-transparent mask
//     ..userInteractions = false; // Prevent user interaction during loading
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // This widget is the root of your application.

//   void fcm() async {
//     String? fcmtoken = await FirebaseMessaging.instance.getToken();

//     print(
//         "<-------------------- FCM TOKEN : $fcmtoken ----------------------------->");
//     setState(() {
//       fcmToken = fcmtoken!;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     fcm();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       // translations: LocaleString(),
//       locale: Locale('en', 'US'),
//       title: 'Go Vendor',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
//         primarySwatch: Colors.blue,
//       ),
//       home: SplashScreen(),
//       builder: EasyLoading.init(),
//     );
//   }
// }






import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:gocut_vendor/color/colors.dart';
import 'package:gocut_vendor/global/data.dart';
import 'package:gocut_vendor/lib/constants/dependency_injection.dart';
import 'package:gocut_vendor/lib/controllers/maincontroller.dart';
import 'localNotifications.dart';
import 'splash_screen.dart';

/// 🔥 REQUIRED for background FCM on Android
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalNotification.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ✅ CORRECT Firebase init for Android
  await Firebase.initializeApp();

  /// Background FCM handler
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  /// Crashlytics
  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterError;
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(true);

  /// ✅ Initialize dependencies BEFORE runApp
  DependencyInjection.init();

  configureEasyLoading();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Maincontroller(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

void configureEasyLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.blue
    ..textColor = Colors.blue
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false;
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    _initFcm();
  }

  Future<void> _initFcm() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      fcmToken = token;
      debugPrint(
        "🔥 FCM TOKEN: $token",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('en', 'US'),
      title: 'Go Vendor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
        ),
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/delivery_agent.dart';
import 'package:delivery_app/models/subscription.dart';
import 'package:delivery_app/routes.dart';
import 'package:delivery_app/screens/auth/auth_view_model.dart';
import 'package:delivery_app/screens/auth/login/login.dart';
import 'package:delivery_app/screens/scanner/scanner_page.dart';
import 'package:delivery_app/screens/scanner/scanner_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   //statusBarColor: Colors.transparent,
  //   //color set to transperent or set your own color
  //   statusBarIconBrightness: Brightness.dark,
  //   //set brightness for icons, like dark background light icons
  // ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(SubscriptionAdapter());
  Hive.registerAdapter(IdAdapter());
  Hive.registerAdapter(DeliveryAgentAdapter());

  await Hive.openBox<Subscription>(kDeliveryBoxName);
  await Hive.openBox<DeliveryAgent>(kDeliveryAgentBoxName);

  final AuthViewModel authViewModel = AuthViewModel();
  final sharedPreferences = await SharedPreferences.getInstance();
  authViewModel.isSessionEnded = await isSessionEnded(sharedPreferences);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => authViewModel),
      ChangeNotifierProvider(create: (context) => ScannerViewModel())
    ],
    child: DeliveryApp(
      isMySessionEnded: authViewModel.isSessionEnded,
    ),
  ));
}

class DeliveryApp extends StatelessWidget {
  final bool? isMySessionEnded;
  const DeliveryApp({Key? key, this.isMySessionEnded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Routes.onGenerateAppRoutes,
      // initialRoute: isMySessionEnded! ? loginRoute : scannerRoute
      home: isMySessionEnded! ? LoginPage() : ScannerPage(),
    );
  }
}

Future<bool> isSessionEnded(SharedPreferences sharedPreferences) async {
  final lastLoggedIn = sharedPreferences.getInt(kLastLoggedIn);
  if (lastLoggedIn == null) return true;
  try {
    final lastLoggedInTimestamp =
        DateTime.fromMillisecondsSinceEpoch(lastLoggedIn);
    final DateTime now = DateTime.now();

    final String lastDeliveredTime =
        sharedPreferences.getString(kLastDeliveredTimestamp) ??
            "1970-01-01 00:00:00";

    final DateTime lastDeliveredDateTime =
        DateFormat(kPostDateFormat).parse(lastDeliveredTime);

    final bool isSessionEnded =
        now.difference(lastLoggedInTimestamp).inHours >= 5;
    final isNextDay = now.difference(lastDeliveredDateTime).inDays > 1;

    if (isSessionEnded || isNextDay) {
      Hive.openBox<DeliveryAgent>(kDeliveryAgentBoxName)
          .then((box) => box.clear());
      Hive.openBox<Subscription>(kDeliveryBoxName).then((box) => box.clear());
    }

    return isSessionEnded;
  } on FormatException {
    return true;
  }
}

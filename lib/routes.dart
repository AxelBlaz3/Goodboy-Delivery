import 'package:delivery_app/constants.dart';
import 'package:delivery_app/screens/auth/login/login.dart';
import 'package:delivery_app/screens/auth/otp/otp_page.dart';
import 'package:delivery_app/screens/scanner/scanner_page.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic>? onGenerateAppRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case otpRoute:
        return MaterialPageRoute(builder: (_) => OTPPage());
      case scannerRoute:
        return MaterialPageRoute(builder: (_) => ScannerPage());
    }
  }
}

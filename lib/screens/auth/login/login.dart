import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/delivery_agent.dart';
import 'package:delivery_app/screens/auth/auth_view_model.dart';
import 'package:delivery_app/screens/scanner/scanner_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mobileController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();

  //   final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  //   authViewModel.auth.authStateChanges().listen((User? user) {
  //     if (user != null && !authViewModel.isSessionEnded) {
  //       // Save session and navigate to scanner.
  //       print('I\'m logging in');
  //       authViewModel.saveSession(context);
  //       Navigator.pushNamedAndRemoveUntil(
  //           context, scannerRoute, (route) => false);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome back!', style: GoogleFonts.poppins(fontSize: 21)),
                Text('Login',
                    style: GoogleFonts.poppins(
                        fontSize: 36,
                        color: Colors.orange[900],
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 32,
                ),
                Text(
                  'MOBILE',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: mobileController,
                  autofocus: true,
                  maxLength: 10,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5),
                  decoration: InputDecoration(
                    prefix: Text(
                      '+91 ',
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.black.withOpacity(.5)),
                    ),
                    filled: true,
                    hintText: '9876543210',
                    fillColor: Color(0xFFEFEFEF),
                    border: InputBorder.none,
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        final ScannerViewModel scannerViewModel =
                            Provider.of<ScannerViewModel>(context,
                                listen: false);

                        final DeliveryAgent? deliveryAgent =
                            await scannerViewModel.getDeliveryAgent(
                                mobile: "+91${mobileController.text}");

                        if (deliveryAgent == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "No delivery agent associated with the given number")));
                          return;
                        }

                        if (!deliveryAgent.isDelivering!) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "This delivery agent has stopped deliveries")));
                          return;
                        }

                        if (authViewModel.timer == null ||
                            !authViewModel.timer!.isActive)
                          authViewModel.sendOtp(context, mobileController.text);
                        else
                          await Navigator.pushNamed(context, otpRoute);
                      },
                      child: Text(
                        'SEND OTP',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange[900],
                          onPrimary: Colors.white,
                          minimumSize: Size(deviceSize.width / 3, 48),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                    ))
              ],
            )));
  }
}

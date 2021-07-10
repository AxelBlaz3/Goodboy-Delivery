import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class AuthViewModel extends ChangeNotifier {
  final int resendOTPTimerLimit = 30;
  String mobile = '';
  Timer? timer;
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationCode = '';
  bool isSessionEnded = true;

  void startTimer() {
    if (timer == null || !timer!.isActive) {
      timer = Timer.periodic(Duration(seconds: 1), timerCallback);
    }
  }

  void timerCallback(Timer timer) {
    if (timer.tick >= resendOTPTimerLimit) timer.cancel();
    notifyListeners();
  }

  void saveSession(BuildContext context) async {
    // Save logged in timestamp in shared preferences.
    final sharedPreferences = await SharedPreferences.getInstance();
    final currentTimestamp = DateTime.now();
    print('Saving timestamp - $currentTimestamp');
    sharedPreferences.setInt(
        kLastLoggedIn, currentTimestamp.millisecondsSinceEpoch);
  }

  void sendOtp(BuildContext context, String mobile,
      {bool isResend = false}) async {
    if (!isResend) this.mobile = mobile;

    await auth.verifyPhoneNumber(
      phoneNumber: '+91$mobile',
      verificationCompleted: (PhoneAuthCredential credential) async {
        print('Verification completed.');
        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);
          verifyAndNavigate(context, userCredential);
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.code == 'invalid-verification-code'
                  ? 'Invalid OTP entered'
                  : 'Some error occured')));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        if (e.code == 'invalid-phone-number') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('The provided phone number is not valid.')));
        } else if (e.code == 'invalid-verification-code') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Invalid OTP entered')));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verificationCode = verificationId;
        if (!isResend) {
          // Navigate to OTP screen
          Navigator.pushNamed(context, otpRoute);
        }

        startTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyCode(BuildContext context, String smsCode) async {
    final authCredential = PhoneAuthProvider.credential(
        verificationId: verificationCode, smsCode: smsCode);
    try {
      UserCredential userCredential =
          await auth.signInWithCredential(authCredential);
      verifyAndNavigate(context, userCredential);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.code == 'invalid-verification-code'
              ? 'Invalid OTP entered'
              : 'Some error occured')));
    }
  }

  void verifyAndNavigate(BuildContext context, UserCredential userCredential) {
    if (userCredential.user != null) {
      saveSession(context);
      isSessionEnded = false;
      Navigator.pushNamedAndRemoveUntil(
          context, scannerRoute, (route) => false);
    }
  }
}

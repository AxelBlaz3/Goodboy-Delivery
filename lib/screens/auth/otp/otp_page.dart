import 'package:delivery_app/screens/auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OTPPage extends StatefulWidget {
  final String? verificationCode;
  const OTPPage({Key? key, this.verificationCode = ''}) : super(key: key);

  @override
  _OTPPageState createState() =>
      _OTPPageState(verificationCode: verificationCode);
}

class _OTPPageState extends State<OTPPage> {
  _OTPPageState({this.verificationCode});

  String? verificationCode;
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Verification',
            style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange[900])),
        SizedBox(
          height: 8,
        ),
        Text(
          'We have sent a verification code to your registered number +91${authViewModel.mobile}',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        SizedBox(
          height: 48,
        ),
        SizedBox(
            width: deviceSize.width / 2,
            child: TextField(
              textAlign: TextAlign.center,
              controller: otpController,
              autofocus: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              maxLines: 1,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 15),
              decoration: InputDecoration(
                filled: true,
                hintText: '______',
                fillColor: Color(0xFFEFEFEF),
                border: InputBorder.none,
              ),
            )),
        SizedBox(
          height: 32,
        ),
        ElevatedButton(
          onPressed: () => authViewModel.verifyCode(context, otpController.text),
          child: Text(
            'VERIFY',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
              primary: Colors.orange[900],
              onPrimary: Colors.white,
              minimumSize: Size(deviceSize.width / 3, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<AuthViewModel>(
                builder: (context, authViewModel, child) => TextButton(
                    style: TextButton.styleFrom(primary: Colors.orange[900]),
                    onPressed: authViewModel.timer != null &&
                            authViewModel.timer!.isActive
                        ? null
                        : () => authViewModel.sendOtp(context, authViewModel.mobile, isResend: true),
                    child: authViewModel.timer != null
                        ? Text(authViewModel.timer!.isActive
                            ? 'Resend code in ${authViewModel.resendOTPTimerLimit - authViewModel.timer!.tick} sec'
                            : 'SEND OTP')
                        : SizedBox()))
          ],
        ),
      ],
    ));
  }
}

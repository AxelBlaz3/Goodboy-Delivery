import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoDeliveries extends StatelessWidget {
  const NoDeliveries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.mood_bad_rounded,
          size: 144,
          color: Colors.orange[900]?.withOpacity(.5),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          'No Deliveries Yet',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Delivered orders appear here. Make sure to scan the barcode to make the status as delivered.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 12, color: Colors.black.withOpacity(.5)),
        )
      ],
    );
  }
}

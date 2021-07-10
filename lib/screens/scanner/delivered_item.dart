import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/subscription.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DeliveredItem extends StatelessWidget {
  final Subscription? subscription;
  const DeliveredItem({Key? key, this.subscription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        elevation: 8,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subscription?.package ?? "Unknown Package",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      DateFormat(kDeliveredDateFormat).format(
                          DateTime.fromMillisecondsSinceEpoch(
                              subscription!.deliveredTimestamp!)),
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(.5)),
                    ),
                  ],
                ),
                Text(
                  "${subscription?.netWeight ?? 'Unknown'}g",
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "${subscription!.address}",
                  style: GoogleFonts.poppins(fontSize: 10),
                )
              ],
            )));
  }
}

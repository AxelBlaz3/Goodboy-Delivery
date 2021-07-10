import 'package:delivery_app/models/subscription.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionItem extends StatefulWidget {
  final Subscription? subscription;
  final bool isSelected;
  const SubscriptionItem({Key? key, this.subscription, this.isSelected = false})
      : super(key: key);

  @override
  _SubscriptionItemState createState() => _SubscriptionItemState();
}

class _SubscriptionItemState extends State<SubscriptionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: widget.isSelected
                ? Colors.orange[900]!.withOpacity(.25)
                : Colors.white,
            border: Border.all(
                color: Colors.orange[900]!.withOpacity(.25), width: 1),
            borderRadius: BorderRadius.circular(4)),
        child: Row(children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.subscription?.package ?? 'Unknown',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                (widget.subscription?.netWeight ?? '0') + 'g',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ],
          )),
          widget.isSelected
              ? Icon(
                  Icons.check,
                  color: Colors.orange[900],
                )
              : SizedBox.shrink()
        ]));
  }
}

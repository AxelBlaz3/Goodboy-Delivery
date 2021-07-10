import 'dart:io';

import 'package:delivery_app/constants.dart';
import 'package:delivery_app/models/address.dart';
import 'package:delivery_app/models/subscription.dart';
import 'package:delivery_app/screens/scanner/delivered_item.dart';
import 'package:delivery_app/screens/scanner/no_deliveries.dart';
import 'package:delivery_app/screens/scanner/scanner_view_model.dart';
import 'package:delivery_app/screens/scanner/subscription_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final ScannerViewModel scannerViewModel =
        Provider.of<ScannerViewModel>(context, listen: false);

    return Scaffold(
        floatingActionButton: ElevatedButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.qr_code_scanner_rounded),
              SizedBox(
                width: 12,
              ),
              Text('SCAN',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ],
          ),
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: Colors.orange[900],
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
          onPressed: () => showDialog(
              context: context,
              builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    height: deviceSize.width * .7,
                    width: deviceSize.width * .7,
                    margin: EdgeInsets.all(16),
                    child:
                        QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
                  ))),
        ),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "Today's Deliveries",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, fontSize: 23),
                )),
            Expanded(
              child: Consumer<ScannerViewModel>(
                  builder: (context, scannerViewModel, child) =>
                      scannerViewModel.deliveries.isEmpty
                          ? NoDeliveries()
                          : ListView.builder(
                              padding: EdgeInsets.only(
                                  bottom: 72, left: 16, right: 16),
                              itemCount: scannerViewModel.deliveries.length,
                              itemBuilder: (context, index) => DeliveredItem(
                                    subscription: scannerViewModel.deliveries
                                        .getAt(
                                            scannerViewModel.deliveries.length -
                                                1 -
                                                index),
                                  ))),
            )
          ],
        )));
  }

  void _onQRViewCreated(QRViewController controller) async {
    final scannerViewModel =
        Provider.of<ScannerViewModel>(context, listen: false);

    this.controller = controller;
    controller.scannedDataStream.listen((barcode) async {
      if (!scannerViewModel.isScanned) {
        scannerViewModel.isScanned = true;
        scannerViewModel
            .getSubscriber('610d2cfa8ac400605c4e7443')
            .then((subscriber) {
          if (subscriber == null) {
            scannerViewModel.isScanned = false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Could not fetch user details. Rescan')));
          } else {
            Navigator.pop(context);
            scannerViewModel.selectedIndices.clear();
            triggerBottomSheet(
                context,
                Expanded(
                    child: _buildSubscriptionsListSheet(
                        context,
                        subscriber.addresses!.last,
                        subscriber.subscriptions ?? <Subscription>[],
                        scannerViewModel.selectedIndices)),
                isDismissable: true,
                enableDrag: true);
          }
        });
        // scannerViewModel.postDeliveryDetails(barcode.code).then(
        //     (Map<bool, int> scanStatus) => triggerBottomSheet(
        //         context,
        //         scanStatus.keys.elementAt(0)
        //             ? _buildScanSuccessWidget(
        //                 scannerViewModel, deliveredTimestamp,
        //                 isAlreadyDelivered: scanStatus.values.elementAt(0) ==
        //                     HttpStatus.conflict)
        //             : _buildScanErrorWidget(scannerViewModel)));
      }
    });
  }

  void triggerBottomSheet(BuildContext context, Widget content,
      {bool isDismissable = false, bool enableDrag = false}) {
    showModalBottomSheet(
        enableDrag: enableDrag,
        isDismissible: isDismissable,
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        builder: (context) => WillPopScope(
            child: Wrap(children: [
              content,
            ]),
            onWillPop: () async => false)).whenComplete(() =>
        Provider.of<ScannerViewModel>(context, listen: false).isScanned =
            false);
  }

  Widget _buildScanSuccessWidget(
      ScannerViewModel scannerViewModel, DateTime deliveredTimestamp,
      {bool isAlreadyDelivered = false}) {
    final formatter = DateFormat(kSuccessDateFormat);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Text(
            isAlreadyDelivered ? 'Already delivered' : 'Delivery success!',
            style:
                GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            isAlreadyDelivered
                ? 'Package has delivered already.'
                : 'Package delivered at ${formatter.format(deliveredTimestamp)}',
            style: GoogleFonts.poppins(),
          ),
          SizedBox(
            height: 24,
          ),
          TextButton(
              onPressed: () {
                scannerViewModel.isScanned = false;
                Navigator.of(context).pop();
              },
              child: Text(
                'DONE',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.orange[900]),
              ))
        ],
      ),
    );
  }

  Widget _buildScanErrorWidget(ScannerViewModel scannerViewModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Text(
            'Oops!',
            style:
                GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Some error occurred. Retry to update the delivery status',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(),
          ),
          SizedBox(
            height: 24,
          ),
          TextButton(
              onPressed: () {
                scannerViewModel.isScanned = false;
                Navigator.of(context).pop();
              },
              child: Text(
                'RETRY',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.orange[900]),
              ))
        ],
      ),
    );
  }

  Widget _buildSubscriptionsListSheet(BuildContext context, Address address,
      List<Subscription> subscriptions, List<int> selectedIndices) {
    final ScannerViewModel scannerViewModel =
        Provider.of<ScannerViewModel>(context, listen: false);

    scannerViewModel.setCapturedImage(null, shouldNotify: false);

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 8,
          ),
          Text('Pick your deliverables',
              style: GoogleFonts.poppins(
                  fontSize: 21, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 16,
          ),
          Consumer<ScannerViewModel>(
              builder: (context, scannerViewModel, child) => Column(
                    children: [
                      for (var index = 0; index < subscriptions.length; index++)
                        InkWell(
                            onTap: () =>
                                scannerViewModel.updateSelectedIndices(index),
                            child: SubscriptionItem(
                                subscription: subscriptions[index],
                                isSelected: selectedIndices.contains(index)))
                    ],
                  )),
          SizedBox(
            height: 24,
          ),
          TextButton(
            onPressed: () async {
              final ImagePicker _imagePicker = ImagePicker();
              final XFile? image = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                  maxWidth: 192,
                  maxHeight: 192);
              scannerViewModel.setCapturedImage(image);
            },
            child: Consumer<ScannerViewModel>(
                builder: (context, scannerViewModel, child) => Text(
                    scannerViewModel.capturedImage == null
                        ? 'CAPTURE'
                        : 'CAPTURE AGAIN',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
            style: TextButton.styleFrom(
                primary: Colors.orange[900],
                backgroundColor: Colors.orange[900]!.withOpacity(.05),
                minimumSize: Size(double.infinity, 48)),
          ),
          SizedBox(
            height: 16,
          ),
          Consumer<ScannerViewModel>(
              builder: (context, scannerViewModel, child) => Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(2, 2),
                            blurRadius: 8,
                            color: Colors.black.withOpacity(.25))
                      ]),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      scannerViewModel.capturedImage == null
                          ? SizedBox()
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(scannerViewModel.capturedImage!.path),
                                fit: BoxFit.cover,
                                height: 72,
                                width: 72,
                              )),
                      SizedBox(
                        width: 16,
                      ),
                      scannerViewModel.capturedImage == null
                          ? Icon(Icons.info_outline_rounded,
                              size: 24.0, color: Colors.red)
                          : Icon(Icons.check_circle_rounded,
                              color: Colors.green, size: 24.0),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Text(
                        scannerViewModel.capturedImage == null
                            ? 'You must capture a photo'
                            : 'Photo captured',
                        style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.onSurface),
                      )),
                      ElevatedButton(
                        onPressed: scannerViewModel.capturedImage == null ||
                                selectedIndices.isEmpty
                            ? null
                            : () {
                                final selectedSubscriptions = <Subscription>[];
                                for (final index in selectedIndices)
                                  if (index < subscriptions.length)
                                    selectedSubscriptions
                                        .add(subscriptions[index]);

                                scannerViewModel
                                    .postDeliveryDetails(
                                        selectedSubscriptions,
                                        address,
                                        scannerViewModel.capturedImage!)
                                    .then((success) {
                                  scannerViewModel.selectedIndices.clear();
                                  Navigator.of(context).pop();
                                  if (success)
                                    triggerBottomSheet(
                                        context,
                                        success
                                            ? _buildScanSuccessWidget(
                                                scannerViewModel,
                                                DateTime.now())
                                            : _buildScanErrorWidget(
                                                scannerViewModel));
                                });
                              },
                        child: Text(
                          'SUBMIT',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange[900],
                            //minimumSize: Size(double.infinity, 48),
                            onPrimary: Colors.white,
                            shape: StadiumBorder()),
                      )
                    ],
                  ))),
        ]));
  }
}

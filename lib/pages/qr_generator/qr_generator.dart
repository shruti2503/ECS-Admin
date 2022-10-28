import 'package:ecsadmin/widgets/tool_tip.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRGeneratorPage extends StatelessWidget {
  QRGeneratorPage({Key? key}) : super(key: key);

  final qrKey = GlobalKey();
  String qrData = 'Our Qr Data';
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTooltip(
              message: 'Back',
              onTap: () => Navigator.pop(context),
              // ignore: prefer_const_constructors
              child: Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF63d4c0),
              ),
            ),
            Center(
              child: RepaintBoundary(
                key: qrKey,
                child: QrImage(
                  data: DateTime(now.year, now.month, now.day)
                      .toString(), //This is the part we give data to our QR
                  //  embeddedImage: , You can add your custom image to the center of your QR
                  //  semanticsLabel:'', You can add some info to display when your QR scanned
                  size: 250,
                  backgroundColor: Colors.white,
                  version: QrVersions.auto, //You can also give other versions
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

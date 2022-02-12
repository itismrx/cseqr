import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';

import 'package:flutter_vibrate/flutter_vibrate.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  bool isFlashLightOn = false;
  bool isCameraPaused = false;
  bool showStatus = false;
  String tmpQrValue = '';
  bool? canVibrate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCanVibrate();
  }

  setCanVibrate() async {
    canVibrate = await Vibrate.canVibrate;
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
        // showStatus = true;
      });
      // TODO: CHECK IF THE SCANNED DATA IS VALID AGAINST THE DATA FROM THE SERVERSIDE

      if (tmpQrValue.isEmpty) {
        //tmpQrValue = result!.code!;
      }
      if (tmpQrValue != result!.code!) {
        if (canVibrate!) {
          Vibrate.vibrate();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Couldn't Vibrate!!")));
        }
        tmpQrValue = result!.code!;
        setState(() {
          showStatus = true;
        });
      }
      await Future.delayed(Duration(seconds: 3), () {
        setState(() {
          showStatus = false;
        });
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No Permission'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
                borderColor: Colors.green,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
          if (showStatus)
            Positioned(
              bottom: 170,
              left: MediaQuery.of(context).size.width * 0.32,
              child: Container(
                  width: 120,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          Icons.done,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Success',
                        style: TextStyle(
                            fontFamily: "Dongle",
                            color: Colors.white,
                            fontSize: 24),
                      )
                    ],
                  )),
            ),
          Positioned(
              top: 30,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
          Positioned(
              top: 30,
              right: 20,
              child: IconButton(
                icon: Icon(
                  Icons.replay,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    tmpQrValue = '##';
                  });
                  print('\n******\n${tmpQrValue}\n****');
                },
              )),
          if (result != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                height: 40,
                child: SelectableText(result!.code!),
              ),
              // child: Text(result!.code!)),
            )
          else
            const Text('No Code'),
          Positioned(
            bottom: 100,
            left: MediaQuery.of(context).size.width * 0.28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await controller?.toggleFlash();
                    setState(() {
                      isFlashLightOn = !isFlashLightOn;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: Icon(isFlashLightOn
                        ? Icons.flashlight_on
                        : Icons.flashlight_off),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    isCameraPaused
                        ? await controller?.resumeCamera()
                        : await controller?.pauseCamera();
                    setState(() {
                      isCameraPaused = !isCameraPaused;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    child:
                        Icon(isCameraPaused ? Icons.play_arrow : Icons.pause),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    await controller?.flipCamera();
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: Icon(Icons.change_circle),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

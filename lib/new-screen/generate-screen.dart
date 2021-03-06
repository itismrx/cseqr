import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class GenerateScreen extends StatefulWidget {
  @override
  _GenerateScreenState createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  String? qrValue = '';
  TextEditingController _qrValueEditingController = TextEditingController();
  GlobalKey genKey = GlobalKey(debugLabel: "qr");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qrValue = _qrValueEditingController.value.text;
  }

  FutureOr<dynamic> takePicture() async {
    RenderRepaintBoundary boundary =
        genKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile = await new File('$directory/photo.png').create();
    imgFile.writeAsBytes(pngBytes);
    return await ImageGallerySaver.saveImage(
      pngBytes,
      quality: 100,
      name: 'qr-code-image-$qrValue',
    );
    // ImageGallerySaver.saveFile(imgFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          child: Image.asset(
            'assets/logo.png',
            width: 70,
            height: 70,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
              ),
              RepaintBoundary(
                key: genKey,
                child: Container(
                  height: 250,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: QrImage(
                          data: qrValue!,
                          version: QrVersions.auto,
                          size: 230,
                          gapless: false,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          errorStateBuilder: (context, err) {
                            return Text('Oh Something went wrong! Try agian');
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Generated by Scaniee',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Dongle",
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 240,
                    child: TextField(
                      controller: _qrValueEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        hintText: "Type anything...",
                        contentPadding: const EdgeInsets.only(left: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        qrValue = _qrValueEditingController.value.text;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.qr_code,
                        color: Colors.white,
                        size: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final val = await takePicture();
                      if (val['isSuccess']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Image Saved Successfully!!"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

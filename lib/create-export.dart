import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class CreateAndExportQR extends StatefulWidget {
  @override
  _CreateAndExportQRState createState() => _CreateAndExportQRState();
}

class _CreateAndExportQRState extends State<CreateAndExportQR> {
  final GlobalKey globalKey = GlobalKey();

  TextEditingController _controller = TextEditingController();
  String? qrValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qrValue = _controller.value.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create & Export",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              alignment: Alignment.center,
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: qrValue!,
                  version: QrVersions.auto,
                  size: 200,
                  gapless: false,
                  backgroundColor: Colors.lightGreen.shade600,
                  foregroundColor: Colors.black,
                  // padding: const EdgeInsets.all(15),
                  embeddedImage: AssetImage('asset/logo.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                      color: Colors.white, size: Size(30, 30)),
                  errorStateBuilder: (context, err) {
                    return Container(
                      child: Text(
                        "Oh,Something went wrong!",
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Write someting...",
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    qrValue = _controller.value.text;
                  });
                },
                child: Text("Generate")),
            ElevatedButton(
                onPressed: () => _export(_controller.value.text),
                child: Text("Export"))
          ],
        )),
      ),
    );
  }

  Future<void> _export(data) async {
    print("Exporeted");
    QrValidationResult qrValidationResult = QrValidator.validate(
        data: data,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.L);

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode!,
        color: Colors.blue,
        gapless: true,
        embeddedImage: null,
        embeddedImageStyle: null,
      );
      Directory tempDir = await getApplicationDocumentsDirectory();
      String tempPath = tempDir.path + Platform.pathSeparator + 'Download';
      final saveDir = Directory(tempPath);
      bool hasExisted = await saveDir.exists();
      String path = "";
      if (hasExisted) {
        path = saveDir.path;
        print("\n saved at $path\n");
      } else {
        final ts = DateTime.now().microsecondsSinceEpoch.toString();
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        path = '$tempPath/$ts.png';
        print("\n saved at $path\n");
      }
      // String path = '/storage/emulated/0/Download/$ts.png';

      final picData =
          await painter.toImageData(2048, format: ui.ImageByteFormat.png);
      await writeToFile(picData!, path);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Image.file(
              File(path),
            ),
          )),
        );
      }));
    }
  }

  Future<void> writeToFile(ByteData data, String path) async {
    print("Written to file");

    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateAndExportQR extends StatelessWidget {
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
      body: Container(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            alignment: Alignment.center,
            child: QrImage(
              data: 'Scan Me',
              version: QrVersions.auto,
              size: 200,
              gapless: false,
              backgroundColor: Colors.lightGreen.shade600,
              foregroundColor: Colors.black,
              // padding: const EdgeInsets.all(15),
              embeddedImage: AssetImage('asset/logo.png'),
              embeddedImageStyle:
                  QrEmbeddedImageStyle(color: Colors.pink, size: Size(50, 50)),
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
          SizedBox(
            height: 20,
          ),
        ],
      )),
    );
  }
}

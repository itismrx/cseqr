import 'package:cseqr/new-screen/generate-screen.dart';
import 'package:cseqr/new-screen/scan-screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const double HEIGHT = 110;
    return Scaffold(
      body: Container(
        height: size.height,
        child: Stack(
          children: [
            Positioned(
              top: 150,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return GenerateScreen();
                  }));
                },
                onHorizontalDragEnd: (details) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return GenerateScreen();
                  }));
                },
                child: Container(
                  height: HEIGHT,
                  alignment: Alignment.center,
                  width: size.width * .75,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 5),
                            blurRadius: 10,
                            spreadRadius: 1)
                      ],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(80),
                          bottomRight: Radius.circular(80))),
                  child: Text(
                    'Generate',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: "Dongle",
                        fontSize: 54),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 150,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ScanScreen();
                  }));
                },
                onHorizontalDragEnd: (details) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ScanScreen();
                  }));
                },
                child: Container(
                  height: HEIGHT,
                  alignment: Alignment.center,
                  width: size.width * .75,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80),
                      bottomLeft: Radius.circular(80),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(2, 5),
                          blurRadius: 10,
                          spreadRadius: 1)
                    ],
                  ),
                  child: Text(
                    'Scan',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: "Dongle",
                        fontSize: 54),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

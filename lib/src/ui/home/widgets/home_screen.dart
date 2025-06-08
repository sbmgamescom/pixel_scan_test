import 'package:flutter/material.dart';
import 'package:pixel_scan_test/src/core/config/images.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    child: Image.asset(AppImages.logoSmall),
                  ),
                  SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0F363636),
                          offset: Offset(0, 1),
                          blurRadius: 1,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x0D363636),
                          offset: Offset(0, 3),
                          blurRadius: 3,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x08363636),
                          offset: Offset(0, 6),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x03363636),
                          offset: Offset(0, 10),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x00363636),
                          offset: Offset(0, 16),
                          blurRadius: 5,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 22, right: 16, bottom: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Documents',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 55.0),
                                child: SizedBox(
                                    height: 220,
                                    child: Image.asset(AppImages.documents)),
                              ),
                            ],
                          ),
                          Text(
                            'No documents found',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: 250,
                            child: Text(
                              'Tap the baton below to scan \nor convert to PDF',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff767676),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 64,
              left: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 68,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x14343434), // #34343414
                            offset: Offset(0, 0),
                            blurRadius: 24,
                            spreadRadius: 0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(88)),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: 100,
                      child: Image.asset(AppImages.buttonScanner),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

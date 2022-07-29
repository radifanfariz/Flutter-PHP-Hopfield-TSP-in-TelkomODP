import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen({Key key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    child: Text(
                      "About",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "By",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        child: Text(
                          "\"Radifan Fariz\"",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 3,
              ),
              Center(
                child: Container(
                    child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "IMPLEMENTASI ALGORITMA ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "CONTINUOUS HOPFIELD NETWORK ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(
                          text:
                              "UNTUK OPTIMASI RUTE TEKNISI KE BEBERAPA LOKASI "),
                      TextSpan(
                        text: "FIBER ACCESS TERMINAL ",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      TextSpan(
                        text: "(FAT) (STUDI KASUS : PT.XYZ)",
                      ),
                    ],
                  ),
                )),
              ),
              Container(
                width: 100,
                child: Image.asset('assets/images/usu.png'),
              ),
              Center(
                child: Container(
                  child: Text(
                    '''PROGRAM STUDI S1 ILMU KOMPUTER
FAKULTAS ILMU KOMPUTER DAN TEKNOLOGI INFORMASI
UNIVERSITAS SUMATERA UTARA
MEDAN
2020
''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import './home.dart';
import './ping.dart';

class Iperf extends StatelessWidget {
  final macField = TextEditingController();
  final String mac = '';
  String message = "";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        drawer: MyDrawer(),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Image.asset("assets/images/logo.png")),
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Container(
            child: Text(
                "En construction, veuillez patienter pendant que je cherche mes outils..."),
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 150.0),
          ),
        ]));
  }
}

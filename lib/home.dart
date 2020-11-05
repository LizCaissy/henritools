import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './main.dart';
import './iperf.dart';
import './ping.dart';

void main() => runApp(MyApp());

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Container(
              height: 60,
              child: DrawerHeader(
                child: Text('Menu', style: TextStyle(color: Colors.white)),
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
              )),
          ListTile(
            leading: Icon(Icons.router),
            title: Text("Cogeco IP"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.network_check),
            title: Text("Iperfs"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Iperf()));
            },
          ),
          ListTile(
            leading: Icon(Icons.wifi_tethering),
            title: Text("Pings"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Ping()));
            },
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final macField = TextEditingController();
  final String mac = '';
  String message = "";

  @override
  void dispose() {
    macField.dispose();
    dispose();
  }

  getIp(mac) async {
    mac = mac.replaceAll(':', '');
    mac = mac.toLowerCase();
    String ip = "";
    var url = 'http://192.168.114.185:5000/' + mac;
    print(url);
    var response =
        await http.get(url, headers: {"Access-Control-Allow-Origin": "*"});
    if (response.statusCode == 200) {
      if (response.body != '') {
        message = "IP du client";
        print('Response status: ${response.statusCode}' +
            " : " +
            '${response.body}');
        ip = response.body.toString();
        return ip;
      } else {
        message = "Wait a minute...";
        ip = "Vous devez saisir une MAC";
        return ip;
      }
    } else {
      ip = "MAC introuvable";
      message = "Oups...";
      print('Response status: ${response.statusCode}');
      return ip;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: MyDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Image.asset("assets/images/logo.png")),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: new DecorationImage(
              image: new AssetImage("assets/images/logo1.png"),
              scale: 1.5,
              alignment: Alignment.bottomRight,
            )),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 150.0),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Row(children: [
              Container(
                  width: screenWidth / 2,
                  padding: EdgeInsets.only(left: 40, top: 120),
                  child: TextFormField(
                    autofocus: true,
                    enableInteractiveSelection: true,
                    controller: macField,
                    onFieldSubmitted: (value) async {
                      var ip = await getIp(macField.text);
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(message),
                            content: SelectableText(ip),
                          );
                        },
                      );
                    },
                    decoration: InputDecoration(
                      labelText: 'Entrez la MAC du modem',
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          tooltip: 'Effacer',
                          onPressed: () => macField.clear()),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                  )),
              Container(
                padding: EdgeInsets.only(top: 120, left: 3),
                child: FloatingActionButton(
                  onPressed: () async {
                    var ip = await getIp(macField.text);
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(message),
                          content: SelectableText(ip),
                        );
                      },
                    );
                  },
                  tooltip: 'Rechercher',
                  child: Icon(Icons.search),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

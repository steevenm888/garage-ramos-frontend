import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'SideDrawer.dart';
import 'loginScreen.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class GarageScreen extends StatefulWidget {
  GarageScreen({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _GarageScreenState createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  bool isOn = false;
  String picture = "images/remote.png";
  String username;
  String userType;

  getUserData() async {
    final storage = new FlutterSecureStorage();
    username = await storage.read(key: 'username');
    userType = await storage.read(key: 'user_type');
    setState(() {
      username = username;
      userType = userType;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          drawer: SideDrawer(username: username ?? '', userType: userType ?? '',),
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(picture, width: 300, fit: BoxFit.fitWidth,),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                FlatButton(
                  onPressed: () async {
                    final storage = new FlutterSecureStorage();
                    String token = await storage.read(key: 'token');
                    if(token != null) {
                      http.Response res = await http.get("https://edificio-ramos.tk:8443/open/garage", headers: {"Authorization":"Bearer "+token});
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FlutterEasyLoading(child: LoginScreen()))
                      );
                    }
                  },
                  child: Text(
                    "Abrir/Cerrar",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.07
                    ),
                  ),
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.07,
                  color: Colors.blueGrey,
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
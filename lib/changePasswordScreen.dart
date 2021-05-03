import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pilight/garageScreen.dart';
import 'package:pilight/loginScreen.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key key, this.title, this.dialog}) : super(key: key);
  final String title;
  final String dialog;


  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState(this.dialog, this.title);
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String password = '';
  String verifyPassword = '';
  String title;
  String dialog;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _ChangePasswordScreenState(String dialog, String title) {
    this.dialog = dialog;
    this.title = title;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> onWillPop() async {
    if(this.dialog == 'Nuevo Usuario') {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlutterEasyLoading(child: LoginScreen()))
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlutterEasyLoading(child: GarageScreen(title: "Garage Edificio Ramos",)))
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Garage Edificio Ramos"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.dialog,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          letterSpacing: 2
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Ingrese la nueva contraseña",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      obscureText: true,
                      onChanged: (val) {
                        this.password = val;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Repita la nueva contraseña",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      obscureText: true,
                      onChanged: (val) {
                        this.verifyPassword = val;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      child: Text("Cambiar la Contraseña"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white60),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                        minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                        elevation: MaterialStateProperty.all<double>(20),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      ),
                      onPressed: () async {
                        EasyLoading.show(status: 'Cargando...');
                        var bytes1 = utf8.encode(password);
                        if(password == verifyPassword) {
                          http.Response res;
                          try{
                            var passwordHash = sha256.convert(bytes1).toString().toUpperCase();
                            final storage = new FlutterSecureStorage();
                            String token = await storage.read(key: 'token');
                            res = await http.put("https://edificio-ramos.tk:8443/api/user/password", headers: {"Authorization":"Bearer "+token}, body: {"password":passwordHash});
                            EasyLoading.dismiss();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GarageScreen(title: 'Garage Edificio Ramos')),
                            );
                          } catch (e) {
                            log(e.toString());
                            EasyLoading.showError('Error: ' + res.body);
                          }
                        } else {
                          EasyLoading.showError('Las contraseñas deben coincidir!');
                        }

                      },
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
            )
        ),
        onWillPop: onWillPop);
  }
}
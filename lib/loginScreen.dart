import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pilight/changePasswordScreen.dart';
import 'package:pilight/garageScreen.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    verifyLogin();
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  verifyLogin() async {
    final storage = new FlutterSecureStorage();
    String token = await storage.read(key: "token");
    log(token ?? "No existe el token");
    if(token != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GarageScreen(title: 'Garage Edificio Ramos')),
      );
    }
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Garage Edificio Ramos"),
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
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
                        labelText: "Ingrese su usuario",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                      onChanged: (val) {
                        this.username = val;
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
                        labelText: "Ingrese su contraseña",
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
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      child: Text("Iniciar Sesión"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white60),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                        minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                        elevation: MaterialStateProperty.all<double>(20),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      ),
                      onPressed: () async {
                        EasyLoading.show(status: 'Cargando...');
                        var bytes1 = utf8.encode(password);         // data being hashed
                        var passwordHash = sha256.convert(bytes1).toString().toUpperCase();
                        http.Response res = await http.post("https://edificio-ramos.tk:8443/api/login", body: {"username":username, "user_password":passwordHash});
                        var data;
                        try{
                          Map<String, dynamic> data = json.decode(res.body);
                          final storage = new FlutterSecureStorage();
                          await storage.write(key: "token", value: data['token']);
                          Map<String, dynamic> user = parseJwt(data['token']);
                          await storage.write(key: 'username', value: user['user']['username']);
                          await storage.write(key: 'user_type', value: user['user']['user_type']);
                          EasyLoading.dismiss();
                          if(password == 'Ramos1234.') {
                            username = '';
                            password = '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FlutterEasyLoading(child: ChangePasswordScreen(title: 'Garage Edificio Ramos', dialog: 'Nuevo Usuario'))),
                            );
                          } else {
                            username = '';
                            password = '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GarageScreen(title: 'Garage Edificio Ramos')),
                            );
                          }

                        } catch (e) {
                          log(e.toString());
                          EasyLoading.showError('Error: ' + res.body);
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
        onWillPop: () async => false);
  }
}
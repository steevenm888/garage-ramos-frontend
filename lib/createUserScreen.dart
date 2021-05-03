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

class CreateUserScreen extends StatefulWidget {
  CreateUserScreen({Key key, this.title}) : super(key: key);
  final String title;


  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  String username = '';
  String userType = 'USER';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Crear nuevo Usuario",
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
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  focusColor: Colors.black12,
                  value: this.userType,
                  iconEnabledColor: Colors.black,
                  items: [
                    'USER',
                    'ADMIN'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.white),)
                    );
                  }).toList(),
                  hint: Text(
                    "Elija el tipo de usuario",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      this.userType = val;
                    });
                  },
                  style: TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  child: Text("Crear Usuario"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white60),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                    minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                    elevation: MaterialStateProperty.all<double>(20),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  ),
                  onPressed: () async {
                    EasyLoading.show(status: 'Cargando...');
                    if(username.length > 6) {
                      http.Response res;
                      try{
                        final storage = new FlutterSecureStorage();
                        String token = await storage.read(key: 'token');
                        res = await http.post("https://edificio-ramos.tk:8443/api/user",
                            body: {"username":username, "user_type":userType},
                            headers: {"Authorization":"Bearer "+token}
                        );
                        if(res.statusCode == 400) {
                          EasyLoading.showError(res.body);
                        } else {
                          EasyLoading.showSuccess(res.body);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GarageScreen(title: 'Garage Edificio Ramos')),
                        );
                      } catch (e) {
                        log(e.toString());
                        EasyLoading.showError('Error: ' + res.body);
                      }
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
    );
  }
}
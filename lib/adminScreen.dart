import 'dart:convert';
import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:pilight/SideDrawer.dart';

class AdminsScreen extends StatefulWidget {

  final String username;
  final String userType;

  const AdminsScreen({Key key, this.username, this.userType}) : super(key: key);

  @override
  _AdminsScreenState createState() => _AdminsScreenState(username: username, userType: userType);
}

class _AdminsScreenState extends State<AdminsScreen> {

  String username;
  String userType;
  List<dynamic> users = [];

  _AdminsScreenState({this.username, this.userType});

  getUsers() async {
    final storage = new FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    http.Response res = await http.get("https://edificio-ramos.tk:8443/api/user", headers: {"Authorization":"Bearer "+token});
    setState(() {
      users = jsonDecode(res.body);
    });
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Garage Edificio Ramos"),
      ),
      drawer: SideDrawer(username: username, userType: userType,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Administración",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 30,
                    letterSpacing: 2
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      "Usuario",
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Tipo",
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Acción",
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ),
                ],
                rows: users.map<DataRow>((user) {
                  return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(user['username'])),
                        DataCell(Text(user['user_type'])),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.replay),
                                color: Colors.orange,
                                onPressed: () async {
                                  EasyLoading.show(status: "Cargando...");
                                  final storage = new FlutterSecureStorage();
                                  String token = await storage.read(key: 'token');
                                  http.Response res = await http.put("https://edificio-ramos.tk:8443/api/user/reset/password/"+user['username'], headers: {"Authorization":"Bearer "+token});
                                  if(res.statusCode == 200) {
                                    EasyLoading.showSuccess(res.body);
                                  } else {
                                    EasyLoading.showError(res.body);
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () async {
                                  EasyLoading.show(status: "Cargando...");
                                  final storage = new FlutterSecureStorage();
                                  String token = await storage.read(key: 'token');
                                  http.Response res = await http.delete("https://edificio-ramos.tk:8443/api/user/"+user['username'], headers: {"Authorization":"Bearer "+token});
                                  if(res.statusCode == 200) {
                                    EasyLoading.showSuccess(res.body);
                                  } else {
                                    EasyLoading.showError(res.body);
                                  }
                                  getUsers();
                                },
                              ),
                            ],
                          )
                        ),
                      ]
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}


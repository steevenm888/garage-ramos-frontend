import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pilight/adminScreen.dart';
import 'package:pilight/changePasswordScreen.dart';
import 'package:pilight/createUserScreen.dart';
import 'package:pilight/garageScreen.dart';
import 'package:pilight/loginScreen.dart';

class SideDrawer extends StatelessWidget {

  final String username;
  final String userType;
  final List<dynamic> users;

  const SideDrawer({Key key, this.username, this.userType, this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'Usuario: '+username,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Control Garage'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GarageScreen(title: 'Garage Edificio Ramos'))
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Cambiar contraseña'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlutterEasyLoading(child: ChangePasswordScreen(title: 'Garage Edificio Ramos', dialog: 'Cambio de Contraseña',)))
              )
            },
          ),
          if (userType == 'ADMIN')
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Crear Usuario'),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlutterEasyLoading(child: CreateUserScreen()))
                )
              },
            ),
          if (userType == 'ADMIN')
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Administrar Usuarios'),
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlutterEasyLoading(child: AdminsScreen(userType: userType, username: username,)))
                );
              },
            ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Cerrar Sesión'),
            onTap: () async {
              final storage = new FlutterSecureStorage();
              await storage.delete(key: 'token');
              await storage.delete(key: 'username');
              await storage.delete(key: 'userType');
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlutterEasyLoading(child: LoginScreen()))
              );
            },
          ),
        ],
      ),
    );
  }
}
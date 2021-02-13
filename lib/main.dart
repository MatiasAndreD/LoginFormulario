import 'package:flutter/material.dart';
import 'package:formulario_bloc_app/src/bloc/provider.dart';
import 'package:formulario_bloc_app/src/pages/HomePage.dart';
import 'package:formulario_bloc_app/src/pages/LoginPage.dart';
import 'package:formulario_bloc_app/src/pages/ProductPage.dart';
import 'package:formulario_bloc_app/src/pages/RegisterPage.dart';
import 'package:formulario_bloc_app/src/preferences/UserPreferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new UserPreferences();
    print(prefs.token);

    return Provider(
      child: MaterialApp(
        title: 'FormularioBloc',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductoPage(),
          'register': (BuildContext context) => RegisterPage(),
        },
        theme: ThemeData(primaryColor: Colors.deepPurple),
      ),
    );
  }
}

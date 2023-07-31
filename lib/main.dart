// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/firebase_options.dart';
import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/login_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true
        ),
        title: 'Peliculas',
        initialRoute: 'login',
        routes: {
          '/': (BuildContext context) => HomePage(),
          'detalle': (BuildContext context) => const PeliculaDetalle(),
          'login': (BuildContext context) => const LoginPage(),
        });
  }
}

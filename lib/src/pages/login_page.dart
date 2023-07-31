import 'package:flutter/material.dart';
import 'package:peliculas/src/widgets/form_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> login() async {
    String usernameInput = username.text.trim();
    String passwordInput = password.text.trim();
    // Validar que los campos no estén vacíos
    if (usernameInput.isEmpty || passwordInput.isEmpty) {
      // Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Por favor, ingrese su usuario y contraseña.'),
      ));
      return;
    }
    // Buscar el documento en Firebase Firestore que corresponde al usuario ingresado
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection('users')
        .doc(usernameInput)
        .get();
    // Si el documento no existe, mostrar un mensaje de error
    if (!document.exists) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('El usuario no existe. Por favor, regístrese.'),
      ));
      username.clear();
      password.clear();
      return;
    }
    // Obtener la contraseña almacenada en el documento
    String storedPassword = document.get('password');
    // Comparar la contraseña ingresada por el usuario con la almacenada en la base de datos
    if (passwordInput == storedPassword) {
      // Si las contraseñas coinciden, navegar a la página siguiente
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/');
      username.clear();
      password.clear();
    } else {
      //Si las contraseñas no coinciden, mostrar un mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('La contraseña es incorrecta.'),
      ));
      password.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff26526A),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 35.0, vertical: 35.0),
            margin:
                const EdgeInsets.symmetric(horizontal: 35.0, vertical: 35.0),
            //color: const Color(0xFF6B8E9F),
            height: 700,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: const Color(0xFF6B8E9F),
              border: Border.all(
                color: Colors.black,
                width: 5.0,
              ),
            ),
            child: Column(
              children: <Widget>[
                const Image(
                  image: AssetImage("assets/img/logo.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 30.0),
                TextField(
                  cursorColor: Colors.black,
                  controller: username,
                  decoration: InputDecoration(
                    hintText: 'Ingrese el Usuario',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextField(
                  cursorColor: Colors.black,
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Ingrese la contraseña',
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFCFDDE3),
                        shadowColor: Colors.white,
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      onPressed: () {
                        setState(() {
                          login();
                        });
                      },
                      child: const Text('Iniciar Sesion',
                          style: TextStyle(fontSize: 17, color: Colors.black)),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFCFDDE3),
                        shadowColor: Colors.white,
                        elevation: 10,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      onPressed: () {},
                      child: const Text('Salir sistema',
                          style: TextStyle(fontSize: 17, color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: const Text(
                    'Si no tiene un usuario, regístrese aquí',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFCFDDE3),
                    shadowColor: Colors.white,
                    elevation: 10,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  onPressed: () {
                    showRegisterDialog(context);
                  },
                  child: const Text('Registrarse',
                      style: TextStyle(fontSize: 17, color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
